require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestAlgorithm
      def initialize(patient, group)
        raise ArgumentError unless Rule::GROUPS.include?(group)
        @patient = patient
        @group = group
      end

      def required_pathology
        required_pathology = []

        rules.each do |rule|
          if rule.param_type.nil?
            required_pathology << rule.request
          else
            if patient_requires_test?(rule)
              required_pathology << rule.request
            end
          end
        end

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
        Rule.where(group: @group)
      end
    end
  end
end
