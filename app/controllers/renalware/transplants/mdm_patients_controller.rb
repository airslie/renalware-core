module Renalware
  module Transplants
    class MDMPatientsController < Renalware::MDMPatientsController
      MODALITY_NAMES = ["Transplant", "Live Donor", "Potential LD"].freeze

      def index
        render_index(modalities: MODALITY_NAMES,
                     page_title: t(".page_title"),
                     view_proc: ->(patient) { patient_transplants_mdm_path(patient) })
      end
    end
  end
end
