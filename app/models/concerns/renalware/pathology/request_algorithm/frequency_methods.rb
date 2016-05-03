require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      module FrequencyMethods
        extend ActiveSupport::Concern

        FREQUENCIES = ["Always", "Once", "Weekly", "Monthly"]

        private

        # NOTE: This method assumes days_ago_observed > 0
        def required_from_frequency?(frequency, days_ago_observed)
          case frequency
            when "Always" then true
            when "Once" then false
            when "Weekly" then days_ago_observed >= 7
            when "Monthly" then days_ago_observed >= 28
          end
        end
      end
    end
  end
end
