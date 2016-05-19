require_dependency "renalware/pathology/request_algorithm/frequency"

module Renalware
  module Pathology
    module RequestAlgorithm
      class Frequency::Monthly < Frequency
        def exceeds?(days)
          days >= 28
        end
      end
    end
  end
end
