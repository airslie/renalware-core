require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :observation_requests
      has_many :observations, through: :observation_requests
      has_many :rules, class_name: "RequestAlgorithm::PatientRule"
    end
  end
end
