class PatientEventType < ActiveRecord::Base
  has_many :patient_event

  validates :name, presence: true
end
