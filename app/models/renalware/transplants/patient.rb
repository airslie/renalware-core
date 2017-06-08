require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class Patient < ActiveType::Record[Renalware::Patient]
      has_one :current_donor_stage, -> { current }, class_name: "DonorStage"

      def has_ever_been_a_donor?
        @has_ever_been_a_donor ||= begin
          donor_modality = "Renalware::Transplants::DonorModalityDescription"
          modality_descriptions.exists?(type: donor_modality)
        end
      end

      def has_ever_been_a_recipient?
        @has_ever_been_a_recipient ||= begin
          recipient_modality = "Renalware::Transplants::RecipientModalityDescription"
          modality_descriptions.exists?(type: recipient_modality)
        end
      end
    end
  end
end
