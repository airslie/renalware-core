module Renalware
  module HD
    class MDMPatientsController < Renalware::MDMPatientsController
      MODALITY_NAMES = "HD".freeze

      def index
        render_index(patient_relation: HD::Patient.all,
                     modalities: MODALITY_NAMES,
                     page_title: t(".page_title"),
                     view_proc: ->(patient) { patient_hd_mdm_path(patient) })
      end
    end
  end
end
