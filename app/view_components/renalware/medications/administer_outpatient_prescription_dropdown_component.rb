module Renalware
  module Medications
    class AdministerOutpatientPrescriptionDropdownComponent < ApplicationComponent
      include PresenterHelper

      pattr_initialize [:patient!]

      def render?
        Renalware.config.outpatient_prescription_administration_enabled
      end

      def prescriptions_to_give_as_outpatient
        @prescriptions_to_give_as_outpatient ||= begin
          prescriptions = patient.prescriptions.includes(:drug).to_be_administered_as_outpatient
          present(prescriptions, PrescriptionPresenter)
        end
      end

      def administration_url(prescription)
        new_medications_prescription_outpatient_administration_path(prescription, format: :html)
      end

      def administration_link_data
        {
          "reveal-id" => "outpatient-prescription-administration-modal",
          "reveal-ajax" => "true"
        }
      end
    end
  end
end
