require_dependency "renalware/pathology/request_algorithm/frequency"

module Renalware
  module Pathology
    module RequestAlgorithm
      class Frequency::Once < Frequency
        # NOTE: The Frequency module will only be called if there was a previous observation
        # so an observation is never required if this method gets called.
        def exceeds?(_days)
          false
        end

        def once?
          true
        end
      end
    end
  end
end
