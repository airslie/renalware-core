require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      module FrequencyMethods
        extend ActiveSupport::Concern

        included do
          validates :frequency_type, presence: true
          validates :frequency_type, inclusion: { in: Frequency.all, allow_nil: true }
        end

        def frequency
          "Renalware::Pathology::RequestAlgorithm::Frequency::#{frequency_type}".constantize.new
        end
      end
    end
  end
end
