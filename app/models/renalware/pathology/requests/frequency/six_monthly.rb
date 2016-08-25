require_dependency "renalware/pathology/requests/frequency"

module Renalware
  module Pathology
    module Requests
      class Frequency::SixMonthly < Frequency
        def observation_required?(last_observed_on)
          last_observed_on > 180
        end
      end
    end
  end
end
