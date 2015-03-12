class Medication < ActiveRecord::Base
  include Concerns::SoftDelete
  attr_accessor :drug_select

  acts_as_paranoid

  has_paper_trail :class_name => 'MedicationVersion'

  belongs_to :patient
  belongs_to :medicate_with, :polymorphic => true
  belongs_to :medication_route

  enum provider: %i(gp hospital home_delivery)

  # validates :medication_id, presence: true
  
end
