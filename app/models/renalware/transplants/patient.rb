require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class Patient < ActiveType::Record[Renalware::Patient]
      def donor?
        modality_descriptions.exists?(type: "Renalware::Transplants::DonorModalityDescription")
      end
    end
  end
end
