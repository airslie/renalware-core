require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class Request
        attr_reader :patient,
                    :global_requests,
                    :patient_requests,
                    :clinic,
                    :consultant,
                    :telephone

        def initialize(params)
          @patient = params[:patient]
          @global_requests = params[:global_requests]
          @patient_requests = params[:patient_requests]
          @clinic = params[:clinic]
          @consultant = params[:consultant]
          @telephone = params[:telephone]
        end

        def global_requests_by_lab
          @global_requests.group_by { |request_description| request_description.lab.name }
        end

        def patient_requests_by_lab
          @patient_requests.group_by { |patient_rule| patient_rule.lab.name }
        end

        def has_global_requests?
          @global_requests.any?
        end

        def has_patient_requests?
          @patient_requests.any?
        end

        def has_tests_required?
          has_global_requests? || has_patient_requests?
        end
      end
    end
  end
end
