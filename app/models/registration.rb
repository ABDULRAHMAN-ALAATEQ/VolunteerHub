class Registration < ApplicationRecord
  belongs_to :opportunity
  belongs_to :student, class_name: 'User', inverse_of: :registrations
  belongs_to :reviewer, class_name: 'User', optional: true
  has_one :certificate, dependent: :restrict_with_error
  validates :student_id, uniqueness: { scope: :opportunity_id }
  validates :status, inclusion: { in: %w[registered submitted approved rejected] }
  validates :hours, numericality: { greater_than: 0 }, allow_nil: true
  validates :activity_note, presence: true, if: -> { status != 'registered' }
  validate :valid_hours
  validate :student_role
  def submit!(value, note)
    with_lock do
      unless %w[registered rejected].include?(status)
        raise ArgumentError, 'Only registered or rejected entries can be submitted.'
      end
      if opportunity.ends_at.future?
        raise ArgumentError, 'Hours can be submitted after the event ends.'
      end

      update!(
        hours: value,
        activity_note: note,
        status: 'submitted',
        review_note: nil,
        reviewer: nil,
        reviewed_at: nil
      )
    end
  end
  def review!(decision, note, actor)
    with_lock do
      raise ArgumentError, 'Only the deanship may review.' unless actor.role == 'deanship'
      raise ArgumentError, 'Only submitted hours can be reviewed.' unless status == 'submitted'
      raise ArgumentError, 'Invalid review decision.' unless %w[approved rejected].include?(decision)
      raise ArgumentError, 'A rejection reason is required.' if decision == 'rejected' && note.blank?
      update!(status: decision, review_note: note, reviewer: actor, reviewed_at: Time.current)
    end
  end
  private
  def student_role
    errors.add(:student, 'must be a student') if student && student.role != 'student'
  end
  def valid_hours
    if status != 'registered' && hours.blank?
      errors.add(:hours, 'are required')
    elsif hours && opportunity && hours > opportunity.duration_hours
      errors.add(:hours, 'cannot exceed the event duration')
    end
  end
end
