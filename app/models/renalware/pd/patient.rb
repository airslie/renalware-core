require_dependency "renalware/pd"

module Renalware
  module PD
    class Patient < ActiveType::Record[Renalware::Patient]
      def treated?
        modalities.with_deleted.any? { |modality| pd_modality?(modality) }
      end

      private

      def pd_modality?(modality)
        ModalityDescription.include?(modality.description)
      end
    end
  end
end
