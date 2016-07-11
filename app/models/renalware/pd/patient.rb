require_dependency "renalware/pd"

module Renalware
  module PD
    class Patient < ActiveType::Record[Renalware::Patient]
      MODALITY_NAMES = ["PD-APD", "PD-CAPD", "PD Rest on HD", "PD-Assisted APD", "PD-PrePD"].freeze

      def treated?
        modalities.with_deleted.any? { |modality| pd_modality?(modality.description) }
      end

      def pd_modality?(description)
        MODALITY_NAMES.include?(description.name)
      end
    end
  end
end
