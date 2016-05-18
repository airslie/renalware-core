require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      module Frequency
        class Weekly < Base
          def exceeds?(days)
            days >= 7
          end
        end
      end
    end
  end
end
