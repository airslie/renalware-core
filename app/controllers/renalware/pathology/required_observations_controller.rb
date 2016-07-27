require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequiredObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        form_params = RequestAlgorithm::FormParamsFactory.new(raw_form_params).build
        request_form = RequestAlgorithm::FormFactory.new(@patient, form_params).build

        render :index, locals:{
          form_options: build_params_for_simple_form,
          request_form: request_form,
          all_clinics: all_clinics,
        }
      end

      private

      def build_params_for_simple_form
        OpenStruct.new(
          patient_ids: [@patient.id],
          clinic_id: raw_form_params[:clinic_id]
        )
      end

      def raw_form_params
        params
          .fetch(:form_options, {})
          .permit(:clinic_id)
      end

      def all_clinics
        Renalware::Clinics::Clinic.ordered
      end
    end
  end
end
