require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class GlobalRuleSet < ActiveRecord::Base
        include FrequencyMethods

        has_many :rules, class_name: "GlobalRule"
        belongs_to :request_description
        belongs_to :clinic, class_name: "Clinics::Clinic"
        validates :request_description, presence: true
        validates :clinic, presence: true

        scope :for_clinic, -> (clinic) { where(clinic: clinic) }

        def required_for_patient?(patient)
          PatientRuleSetDecision.new(patient, self).call
        end
      end
    end
  end
end
