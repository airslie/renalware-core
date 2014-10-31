class PatientEvent < ActiveRecord::Base
  belongs_to :patient_event_type
end
