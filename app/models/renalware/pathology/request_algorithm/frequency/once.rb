require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      module Frequency
        # NOTE: This assumes that the last_observation exists
        class Once < Base
          def self.exceeds?(_days)
            false
          end
        end
      end
    end
  end
end
