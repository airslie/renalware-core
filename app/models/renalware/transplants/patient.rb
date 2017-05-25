require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class Patient < ActiveType::Record[Renalware::Patient]
      has_one :current_donor_stage,
              -> { current },
              class_name: "DonorStage"

      def has_ever_been_a_donor?
        modality_descriptions.exists?(type: "Renalware::Transplants::DonorModalityDescription")
      end

      def has_ever_been_a_recipient?
        modality_descriptions.exists?(type: "Renalware::Transplants::DonorModalityDescription")
      end
    end
  end
end
