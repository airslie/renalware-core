require_dependency "renalware/pd"

module Renalware
  module PD
    class FluidDescription < ApplicationRecord
      has_many :peritonitis_episodes
    end
  end
end
