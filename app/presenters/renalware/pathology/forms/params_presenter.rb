require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Forms
      class ParamsPresenter < SimpleDelegator
        def telephone
          params[:telephone] || doctor.telephone
        end

        def doctor
          @doctor ||= Renalware::Doctor.find(params[:doctor_id])
        end

        def clinic
          @clinic ||= Renalware::Clinics::Clinic.find(params[:clinic_id])
        end

        private

        def params
          __getobj__
        end
      end
    end
  end
end
