require_dependency "renalware/pathology/request_algorithm"

module Renalware
  module Pathology
    module RequestAlgorithm
      class RequestFactory
        def initialize(patient, params)
          @patient = patient
          @params = params
        end

        def build
          RequestFormPresenter.new(
            Request.new(request_params)
          )
        end

        private

        def request_params
          {
            patient: @patient,
            global_requests: global_requests,
            patient_requests: patient_requests,
            clinic: @params[:clinic],
            consultant: @params[:consultant],
            telephone: @params[:telephone]
          }
        end

        def global_requests
          @global_requests ||= @patient.required_observation_requests(@params[:clinic])
        end

        def patient_requests
          @patient_requests ||=
            @patient
            .required_patient_pathology
            .map { |patient_rule| PatientRulePresenter.new(patient_rule) }
        end
      end
    end
  end
end
