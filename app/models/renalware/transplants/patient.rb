require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class Patient < ActiveType::Record[Renalware::Patient]
      has_one :current_donor_stage,
              -> { current },
              class_name: "DonorStage"

      def donor?
        modality_descriptions.exists?(type: "Renalware::Transplants::DonorModalityDescription")
      end
    end
  end
end
