# frozen_string_literal: true

require_dependency "renalware/pathology/requests/frequency"

module Renalware
  module Pathology
    module Requests
      class Frequency::ThreeMonthly < Frequency
        def observation_required?(last_observed_on)
          last_observed_on > 90
        end
      end
    end
  end
end
