# frozen_string_literal: true

require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class MDMPresenter < Renalware::MDMPresenter
      def pathology_code_group_name
        :transplant_mdm
      end

      def recipient_operations
        RecipientOperation.for_patient(patient).reversed
      end

      def cmvdna_pathology
        @cmvdna_pathology ||= pathology_for_codes("CMVD", per_page: 6)
      end
    end
  end
end
