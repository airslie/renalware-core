require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class RequestFormOptions
        attr_reader :patient_ids

        def initialize(params)
          @requested_consultant = params[:consultant]
          @requested_clinic = params[:clinic]
          @requested_telephone  = params[:telephone]
          @patient_ids = params[:patients].map(&:id)
        end

        def telephone
          @telephone ||= find_telephone
        end

        def consultant_id
          consultant.id
        end

        def consultant
          @consultant ||= find_consultant
        end

        def clinic_id
          clinic.id
        end

        def clinic
          @clinic ||= find_clinic
        end

        def all_consultants
          @all_consultants ||= Consultant.ordered
        end

        def all_clinics
          @all_clinics ||= Clinics::Clinic.ordered
        end

        private

        def find_telephone
          if @requested_telephone.present?
            @requested_telephone
          else
            consultant.telephone
          end
        end

        def find_consultant
          if @requested_consultant.present?
            @requested_consultant
          else
            default_consultant
          end
        end

        def find_clinic
          if @requested_clinic.present?
            @requested_clinic
          else
            default_clinic
          end
        end

        def default_consultant
          all_consultants.first
        end

        def default_clinic
          all_clinics.first
        end
      end
    end
  end
end
