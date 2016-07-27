require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class FormParamsFactory
        def initialize(params)
          @params = params
        end

        def build
          {
            clinic: clinic,
            consultant: consultant,
            telephone: telephone
          }
        end

        private

        def clinic
          @clinic ||= requested_clinic || default_clinic
        end

        def consultant
          @consultant ||= requested_consultant || default_consultant
        end

        def telephone
          @telephone ||= requested_telephone || default_telephone
        end

        def requested_clinic
          if @params[:clinic_id].present?
            Renalware::Clinics::Clinic.find(@params[:clinic_id])
          end
        end

        def default_clinic
          Renalware::Clinics::Clinic.ordered.first
        end

        def requested_consultant
          if @params[:consultant_id].present?
            Renalware::Pathology::Consultant.find(@params[:consultant_id])
          end
        end

        def default_consultant
          Renalware::Pathology::Consultant.ordered.first
        end

        def requested_telephone
          @params[:telephone]
        end

        def default_telephone
          consultant.telephone
        end
      end
    end
  end
end
