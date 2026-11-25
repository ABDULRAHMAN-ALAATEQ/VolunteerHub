class Opportunity < ApplicationRecord
  CATEGORIES = ['Community', 'Environment', 'Education', 'Health', 'Campus'].freeze
  belongs_to :organization, class_name: 'User', inverse_of: :opportunities
  has_many :registrations, dependent: :restrict_with_error
  validates :title, :description, :location, :starts_at, :ends_at, presence: true
  validates :title, length: { maximum: 120 }
  validates :category, inclusion: { in: CATEGORIES }
  validates :status, inclusion: { in: %w[open closed] }
  validates :capacity, numericality: {
    only_integer: true, greater_than: 0, less_than_or_equal_to: 10000
  }
  validate :valid_schedule
  validate :valid_owner
  validate :protect_existing_registrations, on: :update
  def remaining
    [capacity - registrations.count, 0].max
  end
  def available?
    status == 'open' && starts_at.future? && remaining.positive?
  end
  def duration_hours
    (ends_at - starts_at) / 3600.0
  end
  def register_student!(student)
    with_lock do
      raise ArgumentError, 'Only students may register.' unless student.role == 'student'
      raise ArgumentError, 'You are already registered.' if registrations.exists?(student: student)
      raise ArgumentError, 'Registration is closed or full.' unless available?
      registrations.create!(student: student)
    end
  end
  private
  def valid_schedule
    errors.add(:ends_at, 'must be after the start') if starts_at && ends_at && ends_at <= starts_at
  end
  def valid_owner
    if organization && organization.role != 'organization'
      errors.add(:organization, 'must have the organization role')
    end
  end
  def protect_existing_registrations
    return unless registrations.exists?
    if capacity && capacity < registrations.count
      errors.add(:capacity, 'cannot be below existing registrations')
    end
    if will_save_change_to_starts_at? || will_save_change_to_ends_at?
      errors.add(:base, 'Schedule cannot be changed after students register.')
    end
  end
end
