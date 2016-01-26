require_dependency "renalware"

module Renalware
  class Provider < ActiveRecord::Base
    def self.codes
      %i(gp hospital home_delivery)
    end

    def self.first
      codes.first
    end
  end
end
