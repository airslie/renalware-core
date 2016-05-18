require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class Frequency::Always < Frequency
        def self.exceeds?(_days)
          true
        end
      end
    end
  end
end
