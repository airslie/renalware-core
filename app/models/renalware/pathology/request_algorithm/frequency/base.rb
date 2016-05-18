require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      module Frequency
        class Base
          def exceeds?(_days)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
