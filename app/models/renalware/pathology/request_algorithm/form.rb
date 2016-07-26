require_dependency "renalware/pathology/request_algorithm"

module Renalware
  module Pathology
    module RequestAlgorithm
      class Form
        attr_reader :patient

        delegate :clinic, :consultant, :telephone, to: :@options

        def initialize(patient, options, global_requests, patient_requests)
          @patient = patient
          @options = options
          @global_requests = global_requests
          @patient_requests = patient_requests
        end

        def global_requests_by_lab
          @global_requests.group_by { |request_description| request_description.lab.name }
        end

        def patient_requests_by_lab
          @patient_requests.group_by { |patient_rule| patient_rule.lab.name }
        end
      end
    end
  end
end
