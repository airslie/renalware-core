require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :observation_requests
      has_many :observations, through: :observation_requests
      has_many :rules, class_name: "Requests::PatientRule"
      has_many :requests, class_name: "Requests::Request"

      def last_request_for_patient_rule(patient_rule)
        requests
          .includes(:patient_rules)
          .where(
            pathology_requests_patient_rules: { id: [patient_rule] }
          )
          .first
      end

      def required_observation_requests(clinic)
        Requests::GlobalAlgorithm.new(self, clinic).determine_required_request_descriptions
      end

      def required_patient_pathology
        Requests::PatientAlgorithm.new(self).determine_required_tests
      end
    end
  end
end
