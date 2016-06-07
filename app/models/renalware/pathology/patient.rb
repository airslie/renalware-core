require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :observation_requests
      has_many :observations, through: :observation_requests
      has_many :rules, class_name: "RequestAlgorithm::PatientRule"

      scope :find_by_patient_ids, -> (patient_ids) { where(id: patient_ids) }

      def required_observation_requests(clinic)
        RequestAlgorithm::Global.new(self, clinic).determine_required_request_descriptions
      end

      def required_patient_pathology
        RequestAlgorithm::Patient.new(self).determine_required_tests
      end
    end
  end
end
