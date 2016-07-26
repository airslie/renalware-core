require_dependency "renalware/pathology/request_algorithm"

module Renalware
  module Pathology
    module RequestAlgorithm
      class FormBuilder
        def initialize(patient, options)
          @patient = patient
          @options = options
        end

        def build
          Form.new(@patient, @options, global_requests, patient_requests)
        end

        private

        def global_requests
          @global_requests ||= @patient.required_observation_requests(clinic_for_algorithm)
        end

        def patient_requests
          @patient_requests ||=
            @patient
              .required_patient_pathology
              .map { |patient_rule| PatientRulePresenter.new(patient_rule) }
        end

        def clinic_for_algorithm
          @options.clinic
        end
      end
    end
  end
end
