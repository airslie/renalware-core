require_dependency "renalware"

module Renalware
  class Provider < ActiveRecord::Base
    def self.codes
      %i(gp hospital home_delivery)
    end
  end
end
