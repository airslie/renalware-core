require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class FormsController < Pathology::BaseController
      layout "renalware/layouts/printable"
      before_filter :load_patients

      def create
        request_form_options = RequestAlgorithm::RequestFormOptions.new(request_form_params)
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
        patients_hash = Pathology::Patient.find(patient_ids).index_by(&:id)

        @patients = patient_ids.map { |id| patients_hash[id] }
        authorize Renalware::Patient
      end

      def request_form_params
        params
          .require(:request_form_options)
          .permit(:user_id, :clinic_id, :telephone, patient_ids: [])
      end
    end
  end
end
