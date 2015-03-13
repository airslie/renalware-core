class InfectionOrganism < ActiveRecord::Base

  belongs_to :organism_code
  belongs_to :infectable, :polymorphic => true  

end
