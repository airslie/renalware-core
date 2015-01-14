class PatientMedication < ActiveRecord::Base
  attr_accessor :drug_select

  belongs_to :medication, :polymorphic => true
  belongs_to :patients

  enum route: %i(po iv sc im other)
  enum provider: %i(gp hospital home_delivery)

  # validates :medication_id, presence: true
  
end
