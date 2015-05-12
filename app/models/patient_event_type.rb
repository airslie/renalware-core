class PatientEventType < ActiveRecord::Base
  acts_as_paranoid

  has_many :patient_event

  validates :name, presence: true

end
