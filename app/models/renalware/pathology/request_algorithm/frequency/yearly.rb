require_dependency "renalware/pathology/request_algorithm/frequency"

module Renalware
  module Pathology
    module RequestAlgorithm
      class Frequency::Yearly < Frequency
        def exceeds?(days)
          days >= 365
        end
      end
    end
  end
end
