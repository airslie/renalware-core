module Renalware
  class InfectionOrganism < ActiveRecord::Base

    belongs_to :organism_code
    belongs_to :infectable, :polymorphic => true

    validates :organism_code, uniqueness: {
      scope: [:infectable_id, :infectable_type]
    }, presence: true

  end
end