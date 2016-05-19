require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class FormsController < Pathology::BaseController
      layout "renalware/layouts/printable"
      before_filter :load_patients

      def index
        @form_settings = FormSettings.new(params)
        @patients = Renalware::Pathology::RequestFormsPresenter.wrap(@patients, @form_settings.clinic)
        @patient_ids = @patients.map(&:id).join(",")
        @doctors = Renalware::Doctor.all
        @clinics = Renalware::Clinics::Clinic.all
      end

      private

      def load_patients
        @patients = Renalware::Pathology::Patient.where(id: params[:patient_ids].split(","))
        authorize @patients
      end

      class FormSettings
        def initialize(params)
          @params = params
        end

        def telephone
          @params[:telephone] || 123456  # TODO: Store the doctor's telephone number in DB
        end

        def doctor
          @doctor ||= begin
            if @params[:doctor_id].present?
              Renalware::Doctor.find(@params[:doctor_id])
            else
              Renalware::Doctor.first
            end
          end
        end

        def clinic
          @clinic ||= begin
            if @params[:clinic_id].present?
              Renalware::Clinics::Clinic.find(@params[:clinic_id])
            else
              Renalware::Clinics::Clinic.first
            end
          end
        end
      end
    end
  end
end
