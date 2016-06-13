require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class FormsController < Pathology::BaseController
      layout "renalware/layouts/printable"
      before_filter :load_patients

      def index
        doctor = Doctor.find(params[:doctor_id])
        clinic = Clinics::Clinic.find(params[:clinic_id])

        request_forms = RequestFormPresenter.wrap(
          @patients, clinic, doctor, params.slice(:telephone)
        )

        render :index, locals: { request_forms: request_forms }
      end

      private

      def load_patients
        @patients = Pathology::Patient.find(params[:patient_ids])
        authorize Renalware::Patient
      end
    end
  end
end
