module Renalware
  module PD
    class MDMPatientsController < Renalware::MDMPatientsController
      MODALITY_NAMES = %w(PD APD CAPD).freeze

      def index
        render_index(patient_relation: PD::Patient.all,
                     modalities: MODALITY_NAMES,
                     page_title: t(".page_title"),
                     view_proc: ->(patient) { patient_pd_mdm_path(patient) })
      end
    end
  end
end
