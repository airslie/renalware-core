require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class GlobalRuleSet < ActiveRecord::Base
        include FrequencyMethods

        has_many :rules, as: :rule_set, class_name: "GlobalRule"

        belongs_to :request_description
        belongs_to :clinic, class_name: "Clinics::Clinic"
        validates :request_description, presence: true
        validates :clinic, presence: true
        validate :constrain_request_description

        scope :for_clinic, ->(clinic) { where(clinic: clinic) }
        scope :ordered, -> do
          includes(request_description: :lab)
            .order("pathology_labs.name ASC, pathology_request_descriptions.code ASC")
        end

        def observation_required_for_patient?(patient, date)
          PatientRuleSetDecision.new(patient, self, date).call
        end

        def to_s
          if rules.length >= 1
            rules_str = rules.map { |rule| rule.to_s }.join(" and ")
            "if #{rules_str} then #{frequency}"
          else
            frequency.to_s
          end
        end

        private

        def constrain_request_description
          return unless request_description.present?

          validate_presence_of_required_observation_description_for_request_description
          validate_presence_of_bottle_type_for_request_description
        end

        def validate_presence_of_required_observation_description_for_request_description
          return if request_description.required_observation_description.present?
          errors.add(:request_description, "required observation description can't be blank")
        end

        def validate_presence_of_bottle_type_for_request_description
          return if request_description.bottle_type.present?
          errors.add(:request_description, "bottle type can't be blank")
        end
      end
    end
  end
end
