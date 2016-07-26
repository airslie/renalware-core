require_dependency "renalware/pd"

module Renalware
  module PD
    class FluidDescription < ActiveRecord::Base
      has_many :peritonitis_episodes
    end
  end
end
