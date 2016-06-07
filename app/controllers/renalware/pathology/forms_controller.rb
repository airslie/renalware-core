require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class FormsController < Pathology::BaseController
      layout "renalware/layouts/printable"
      before_filter :load_patients

      def index
        form_params =
          Renalware::Pathology::FormParamsDecorator.new(params)
        patients =
          Renalware::Pathology::RequestFormsDecorator.wrap(@patients, form_params.clinic)

        render :index, locals: {
          form_params: form_params,
          patients: patients,
          doctors: Renalware::Doctor.ordered,
          clinics: Renalware::Clinics::Clinic.ordered
        }
      end

      private

      def load_patients
        @patients = Renalware::Pathology::Patient.find_by_patient_ids(
          params[:patient_ids].split(",")
        )
        authorize @patients
      end
    end
  end
end
