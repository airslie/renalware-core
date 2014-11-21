class PatientMedication < ActiveRecord::Base

  belongs_to :medication, :polymorphic => true
  belongs_to :patients

  enum route: %i(po iv sc im other)
  enum provider: %i(gp hospital home_delivery)
  
end
