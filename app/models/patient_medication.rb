class PatientMedication < ActiveRecord::Base

  belongs_to :medication, :polymorphic => true
  belongs_to :patients

end
