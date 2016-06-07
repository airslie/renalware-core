require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class FormsController < Pathology::BaseController
      layout "renalware/layouts/printable"
      before_filter :load_patients
      before_filter :authorize_patients

      def index
        form_params = FormParamsDecorator.new(params)
        patients = RequestFormsDecorator.wrap(@patients, form_params.clinic)

        render :index, locals: {
          form_params: form_params,
          patients: patients,
          doctors: Doctor.ordered,
          clinics: Clinics::Clinic.ordered
        }
      end

      private

      def load_patients
        @patients = Pathology::Patient.find(
          params[:patient_ids].split(",")
        )
      end

      def authorize_patients
        @patients.each { |patient| authorize patient }
      end
    end
  end
end
