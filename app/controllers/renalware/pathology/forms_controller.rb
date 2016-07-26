require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class FormsController < Pathology::BaseController
      layout "renalware/layouts/printable"
      before_filter :load_patients

      def create
        options = RequestAlgorithm::FormOptions.new(
          clinic: find_clinic,
          patients: @patients,
          consultant: find_consultant,
          telephone: request_form_params[:telephone]
        )
        request_forms = RequestAlgorithm::FormsFactory.new(@patients, options).build

        render :create, locals: {
          request_form_options: options,
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
