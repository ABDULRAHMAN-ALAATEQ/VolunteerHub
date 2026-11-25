require "securerandom"
class Certificate < ApplicationRecord
  belongs_to :registration
  belongs_to :issuer, class_name: 'User'
  validates :registration_id, uniqueness: true
  validates :code, presence: true, uniqueness: true
  def self.issue!(registration, issuer)
    registration.with_lock do
      unless issuer.role == 'deanship'
        raise ArgumentError, 'Only the deanship may issue certificates.'
      end
      unless registration.status == 'approved'
        raise ArgumentError, 'Only approved hours can be certified.'
      end

      registration.certificate || registration.create_certificate!(
        issuer: issuer,
        code: "VH-#{SecureRandom.hex(6).upcase}",
        student_name: registration.student.name,
        opportunity_title: registration.opportunity.title,
        hours: registration.hours,
        issued_at: Time.current
      )
    end
  end
end
