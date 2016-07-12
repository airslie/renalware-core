require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class ModalityDescription < ActiveType::Record[Renalware::Modalities::Description]
      def donation?
        name == "Live Donor"
      end
    end
  end
end
