require_dependency "renalware/hd"

module Renalware
  module HD
    class Patient < ActiveType::Record[Renalware::Patient]
      def treated?
        modality_descriptions.exists?(type: "Renalware::HD::ModalityDescription")
      end
    end
  end
end
