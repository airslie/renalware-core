require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      module Frequency
        # NOTE: This assumes that the last_observation exists
        class Base
          def exceeds?(_days)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
