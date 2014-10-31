class PatientEventType < ActiveRecord::Base
  has_many :patient_event
end
