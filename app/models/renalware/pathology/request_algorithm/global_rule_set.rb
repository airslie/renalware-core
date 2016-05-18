require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class GlobalRuleSet < ActiveRecord::Base
        has_many :rules, class_name: "GlobalRule"
        belongs_to :request_description
        belongs_to :clinic, class_name: "Clinics::Clinic"

        validates :request_description, presence: true
        validates :clinic, presence: true
        validates :frequency_type, presence: true, inclusion: { in: FREQUENCIES }

        scope :for_clinic, -> (clinic) { where(clinic: clinic) }

        def required_for_patient?(patient)
          PatientRuleSetDecision.new(patient, self).call
        end
      end
    end
  end
end
