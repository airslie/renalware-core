require_dependency "renalware/pathology/requests/frequency"

module Renalware
  module Pathology
    module Requests
      class Frequency::Weekly < Frequency
        def observation_required?(last_observed_on)
          last_observed_on >= 7
        end
      end
    end
  end
end
