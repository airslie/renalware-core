require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      module Frequency
        class Always < Base
          def self.exceeds?(_days)
            true
          end
        end
      end
    end
  end
end
