require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class FormsController < Pathology::BaseController
      layout "renalware/layouts/printable"
      before_filter :load_patients

      def index
        form_params = Forms::ParamsPresenter.new(params)
        patients = Forms::PatientPresenter.wrap(@patients, form_params.clinic)

        render :index, locals: {
          form_params: form_params,
          patients: patients,
          doctors: Doctor.ordered,
          clinics: Clinics::Clinic.ordered
        }
      end

      private

      def load_patients
        @patients = Pathology::Patient.find(params[:patient_ids])
        authorize Renalware::Patient
      end
    end
  end
end
