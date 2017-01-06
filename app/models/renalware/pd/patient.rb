require_dependency "renalware/pd"

module Renalware
  module PD
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :pet_adequacy_results

      def treated?
        modality_descriptions.exists?(type: "Renalware::PD::ModalityDescription")
      end
    end
  end
end
