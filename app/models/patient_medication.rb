class PatientMedication < ActiveRecord::Base

  belongs_to :medication, :polymorphic => true
  belongs_to :patients

  enum provider: %i(gp hospital home_delivery)
  
end
