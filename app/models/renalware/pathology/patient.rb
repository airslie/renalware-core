require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :observation_requests
      has_many :observations, through: :observation_requests
      has_many :rules, class_name: "Requests::PatientRule"
      has_many :requests, class_name: "Requests::Request"

      def required_observation_requests(clinic)
        Requests::Global.new(self, clinic).determine_required_request_descriptions
      end

      def required_patient_pathology
        Requests::Patient.new(self).determine_required_tests
      end
    end
  end
end
