require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class Patient < ActiveType::Record[Renalware::Patient]
      def donor?
        modalities.with_deleted.any? { |modality| Transplants::ModalityDescription.donation?(modality.description) }
      end
    end
  end
end
