require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class FormParamsDecorator < SimpleDelegator
      def telephone
        params[:telephone] || doctor.telephone
      end

      def doctor
        @doctor ||= begin
          if params[:doctor_id].present?
            Renalware::Doctor.find(params[:doctor_id])
          else
            Renalware::Doctor.first
          end
        end
      end

      def clinic
        @clinic ||= begin
          if params[:clinic_id].present?
            Renalware::Clinics::Clinic.find(params[:clinic_id])
          else
            Renalware::Clinics::Clinic.first
          end
        end
      end

      private

      def params
        __getobj__
      end
    end
  end
end
