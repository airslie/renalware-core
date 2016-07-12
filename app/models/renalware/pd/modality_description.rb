require_dependency "renalware/pd"

module Renalware
  module PD
    class ModalityDescription < ActiveType::Record[Renalware::Modalities::Description]
      NAMES = ["PD-APD", "PD-CAPD", "PD Rest on HD", "PD-Assisted APD", "PD-PrePD"].freeze

      def self.include?(record)
        NAMES.include?(record.name)
      end
    end
  end
end
