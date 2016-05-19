require_dependency "renalware/pathology/request_algorithm/frequency"

module Renalware
  module Pathology
    module RequestAlgorithm
      class Frequency::Always < Frequency
        def exceeds?(_days)
          true
        end
      end
    end
  end
end
