require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class Patient < ActiveType::Record[Renalware::Patient]
      def donor?
        modalities.with_deleted.any? do |modality|
          Transplants.cast_modality_description(modality.description).donation?
        end
      end
    end
  end
end
