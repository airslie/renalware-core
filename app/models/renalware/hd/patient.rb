require_dependency "renalware/hd"

module Renalware
  module HD
    class Patient < ActiveType::Record[Renalware::Patient]
      def treated?
        modalities.with_deleted.any? { |modality| hd_modality?(modality) }
      end

      private

      def hd_modality?(modality)
        ModalityDescription.include?(modality.description)
      end
    end
  end
end
