require_dependency "renalware/hd"

module Renalware
  module HD
    class ModalityDescription < ActiveType::Record[Renalware::Modalities::Description]
      NAMES = ["Home HD", "Unit HD", "HD Ward", "HD-ARF", "PD-PrePD"].freeze

      def self.include?(record)
        NAMES.include?(record.name)
      end
    end
  end
end
