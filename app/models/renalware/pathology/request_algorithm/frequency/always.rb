require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      module Frequency
        class Always < Base
          def exceeds?(_days)
            true
          end
        end
      end
    end
  end
end
