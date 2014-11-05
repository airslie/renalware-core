class PatientEventType < ActiveRecord::Base
  has_many :patient_event

  validates :name, presence: true

  default_scope{ where(deleted_at: nil) }
end
