class PatientEvent < ActiveRecord::Base
  belongs_to :patients
  belongs_to :patient_event_type

  validates :patient_event_type_id, :date_time, :user_id,
      :description, :notes, :presence => true 
end
