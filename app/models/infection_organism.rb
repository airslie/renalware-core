class InfectionOrganism < ActiveRecord::Base

  belongs_to :organism_code
  belongs_to :sensitivity
  belongs_to :infectable, :polymorphic => true 

  validates :organism_code, uniqueness: { scope: :infectable } 

end
