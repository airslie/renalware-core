require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class Frequency::Weekly < Frequency
        def exceeds?(days)
          days >= 7
        end
      end
    end
  end
end
