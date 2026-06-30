module Renalware
  module Medications
    class OutpatientPrescriptionLastAdministrationComponent < ApplicationComponent
      pattr_initialize [:prescription!]

      def last_administration
        return if prescription.blank?

        @last_administration ||=
          OutpatientPrescriptionAdministrationsQuery.call(prescription:).first
      end

      def fixed_dose_progress
        return if prescription.blank?

        prescription_presenter.fixed_dose_progress
      end

      def fixed_dose_progress_description
        return if fixed_dose_progress.blank?

        given, total = fixed_dose_progress.split("/")
        "#{given} of #{total} already given"
      end

      def render?
        last_administration.present? || fixed_dose_progress.present?
      end

      private

      def prescription_presenter
        @prescription_presenter ||= if prescription.respond_to?(:fixed_dose_progress)
                                      prescription
                                    else
                                      PrescriptionPresenter.new(prescription)
                                    end
      end
    end
  end
end
