require_dependency "renalware/hd"

module Renalware
  module HD
    class PreferenceSet < ActiveRecord::Base
      belongs_to :hospital_unit
    end
  end
end
