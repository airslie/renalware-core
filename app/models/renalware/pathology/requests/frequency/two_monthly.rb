# frozen_string_literal: true

require_dependency "renalware/pathology/requests/frequency"

module Renalware
  module Pathology
    module Requests
      class Frequency::TwoMonthly < Frequency
        def observation_required?(last_observed_on)
          last_observed_on > 60
        end
      end
    end
  end
end
