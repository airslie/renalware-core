require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class FormsController < Pathology::BaseController
      layout "renalware/layouts/printable"
      before_filter :load_patient
      before_filter :load_bookmarks

      def index
        request_form_options = RequestAlgorithm::RequestFormOptions.new(request_form_params)
        request_forms = RequestFormPresenter.wrap(
          @patients, request_form_options
        )

        render :index, locals: {
          request_form_options: request_form_options,
          request_forms: request_forms,
        }
      end

      private

      def load_patients
        @patients = Pathology::Patient.find(request_form_params[:patient_ids])
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
