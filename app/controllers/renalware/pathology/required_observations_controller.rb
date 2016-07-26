require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequiredObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        form_options = RequestAlgorithm::FormOptions.new(
          patients: Array(@patient),
          clinic: clinic
        )
        form = RequestAlgorithm::FormFactory.new(@patient, form_options).build

        render :index, locals: {
          request_form: form,
          request_form_options: form_options
        }
      end

      private

      def clinic
        @clinic ||= begin
          if params[:clinic_id].present?
            Renalware::Clinics::Clinic.find(params[:clinic_id])
          else
            Renalware::Clinics::Clinic.ordered.first
          end
        end
      end
    end
  end
end
