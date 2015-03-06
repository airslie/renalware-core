require 'medication_route'

class PatientMedication < ActiveRecord::Base
  include Concerns::SoftDelete
  attr_accessor :drug_select

  acts_as_paranoid

  has_paper_trail :class_name => 'PatientMedicationVersion'

  belongs_to :medication, :polymorphic => true
  belongs_to :patients

  enum provider: %i(gp hospital home_delivery)

  # validates :medication_id, presence: true
  
end
