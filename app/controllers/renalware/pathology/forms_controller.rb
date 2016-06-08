require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class FormsController < Pathology::BaseController
      layout "renalware/layouts/printable"
      before_filter :load_patients

      def index
        doctors = Doctor.ordered
        clinics = Clinics::Clinic.ordered
        form_params = Forms::ParamsPresenter.new(params, doctors, clinics)
        patients = Forms::PatientPresenter.wrap(@patients, form_params.clinic)

        render :index, locals: {
          form_params: form_params,
          patients: patients,
          doctors: doctors,
          clinics: clinics
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
