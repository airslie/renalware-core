require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class GlobalRuleSet < ActiveRecord::Base
        include FrequencyMethods

        has_many :rules, class_name: "GlobalRule"
        belongs_to :request_description
        belongs_to :clinic, class_name: "Clinics::Clinic"
        validates :request_description, presence: true
        validates :clinic, presence: true
        validate :request_description_valid_for_algorithm?

        scope :for_clinic, -> (clinic) { where(clinic: clinic) }
        scope :ordered, -> do
          includes(request_description: :lab)
            .order("pathology_labs.name ASC, pathology_request_descriptions.code ASC")
        end

        def required_for_patient?(patient)
          PatientRuleSetDecision.new(patient, self).call
        end

        def request_description_valid_for_algorithm?
          if request_description.required_observation_description_id.nil?
            errors.add(:request_description, "must have required_observation_description_id set")
          end

          if request_description.bottle_type.nil?
            errors.add(:request_description, "must have bottle_type set")
          end
        end
      end
    end
  end
end
