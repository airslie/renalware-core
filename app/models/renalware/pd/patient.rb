# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :pet_adequacy_results, dependent: :restrict_with_exception

      def treated?
        modality_descriptions.exists?(type: "Renalware::PD::ModalityDescription")
      end

      def has_ever_been_on_pd?
        @has_ever_been_on_pd ||=
          modality_descriptions.exists?(type: "Renalware::PD::ModalityDescription")
      end
    end
  end
end
