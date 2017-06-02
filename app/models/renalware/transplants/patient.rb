require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class Patient < ActiveType::Record[Renalware::Patient]
      has_one :current_donor_stage,
              -> { current },
              class_name: "DonorStage"

      def has_ever_been_a_donor?
        donor_modality = "Renalware::Transplants::DonorModalityDescription"
        @has_ever_been_a_donor ||= modality_descriptions.exists?(type: donor_modality)
      end

      def has_ever_been_a_recipient?
        recipient_modality = "Renalware::Transplants::RecipientModalityDescription"
        @has_ever_been_a_recipient ||= modality_descriptions.exists?(type: recipient_modality)
      end
    end
  end
end
