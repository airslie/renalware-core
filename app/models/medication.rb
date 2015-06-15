class Medication < ActiveRecord::Base
  attr_accessor :drug_select

  acts_as_paranoid

  has_paper_trail :class_name => 'MedicationVersion'

  belongs_to :patient
  belongs_to :medicatable, :polymorphic => true
  belongs_to :treatable, :polymorphic => true
  belongs_to :medication_route

  validates :medicatable, presence: true
  validates :dose, presence: true
  validates :medication_route_id, presence: true
  validates :frequency, presence: true

  enum provider: %i(gp hospital home_delivery)
end
