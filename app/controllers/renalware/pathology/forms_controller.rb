require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class FormsController < Pathology::BaseController
      layout "renalware/layouts/printable"
      before_filter :load_patients

      def create
        request_form_options = RequestAlgorithm::RequestFormOptions.new(
          clinic: find_clinic,
          patients: find_patients,
          consultant: find_consultant,
          telephone: request_form_params[:telephone]
        )

        request_forms = RequestFormPresenter.wrap(
          @patients, request_form_options
        )

        render :create, locals: {
          request_form_options: request_form_options,
          request_forms: request_forms,
        }
      end

      private

      # NOTE: Preserve the order of the id's given in the params
      def load_patients
        patient_ids = request_form_params[:patient_ids].map(&:to_i)
        @patients = Pathology::OrderedPatientQuery.new(patient_ids).call
        authorize Renalware::Patient
      end

      def find_clinic
        return unless request_form_params[:clinic_id].present?

        Clinics::Clinic.find(request_form_params[:clinic_id])
      end

      def find_patients
        Renalware::Patient.find(request_form_params[:patient_ids])
      end

      def find_consultant
        return unless request_form_params[:consultant_id].present?

        Consultant.find(request_form_params[:consultant_id])
      end

      def request_form_params
        params
          .require(:request_form_options)
          .permit(:consultant_id, :clinic_id, :telephone, patient_ids: [])
      end
    end
  end
end
