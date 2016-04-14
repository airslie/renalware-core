require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestAlgorithm
      class Global
        def initialize(patient, group)
          raise ArgumentError unless GlobalRule::GROUPS.include?(group)
          @patient = patient
          @group = group
        end

        def required_pathology
          required_pathology = []

          # TODO: Make this work

          required_pathology
        end

        private

        def patient_requires_test?(rule)
          param_type_class =
            "::Renalware::Pathology::RequestAlgorithm::ParamType::#{rule.param_type}".constantize

          param_type_class
            .new(@patient, rule.param_identifier, rule.param_value)
            .patient_requires_test?
        end

        def rules
          GlobalRule.where(group: @group)
        end
      end
    end
  end
end
