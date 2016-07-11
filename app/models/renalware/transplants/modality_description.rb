require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class ModalityDescription < ActiveType::Record[Renalware::Modalities::Description]
      def self.donation?(record)
        record.name == "Live Donor"
      end
    end
  end
end
