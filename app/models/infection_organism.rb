class InfectionOrganism < ActiveRecord::Base

  belongs_to :organism_code
  belongs_to :infectable, :polymorphic => true

  validates :organism_code_id, uniqueness: { scope: [:infectable_id, :infectable_type] }, presence: { message: "Organism can't be blank" }

end
