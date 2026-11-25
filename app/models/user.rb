require "uri"
class User < ApplicationRecord
  has_secure_password
  has_many :opportunities, foreign_key: :organization_id,
  inverse_of: :organization, dependent: :restrict_with_error
  has_many :registrations, foreign_key: :student_id, inverse_of: :student,
  dependent: :restrict_with_error
  validates :name, :email, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: %w[student organization deanship] }
  before_validation { self.email = email.to_s.strip.downcase }
end
