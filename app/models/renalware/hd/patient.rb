require_dependency "renalware/hd"

module Renalware
  module HD
    class Patient < ActiveType::Record[Renalware::Patient]
      HD_NAMES = ["Home HD", "Unit HD", "HD Ward", "HD-ARF", "PD-PrePD"].freeze

      def treated?
        modalities.with_deleted.any? { |modality| hd_modality?(modality.description) }
      end

      def hd_modality?(description)
        HD_NAMES.include?(description.name)
      end
    end
  end
end
