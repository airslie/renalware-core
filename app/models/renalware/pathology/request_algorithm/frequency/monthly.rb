require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      module Frequency
        class Monthly < Base
          def exceeds?(days)
            days >= 28
          end
        end
      end
    end
  end
end
