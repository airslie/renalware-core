require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Forms
      class ParamsPresenter < SimpleDelegator
        def initialize(params, doctors, clinics)
          @doctors = doctors.index_by(&:id)
          @clinics = clinics.index_by(&:id)
          super(params)
        end

        def telephone
          params[:telephone] || doctor.telephone
        end

        def doctor
          @doctors[params[:doctor_id].to_i]
        end

        def clinic
          @clinics[params[:clinic_id].to_i]
        end

        private

        def params
          __getobj__
        end
      end
    end
  end
end
