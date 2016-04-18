require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestAlgorithm
      class Global
        def initialize(patient, regime)
          raise ArgumentError unless GlobalRule::REGIMES.include?(regime)
          @patient = patient
          @regime = regime
        end

        def required_pathology
          required_pathology = []

          # TODO: Make this work

          required_pathology
        end

        private

        def patient_requires_test?(rule)
          return true unless rule.has_param?

          param_type_class =
            "::Renalware::Pathology::RequestAlgorithm::ParamType::#{rule.param_type}"
            .constantize

          param_type_class
            .new(
              @patient,
              rule.param_id,
              rule.param_comparison_operator,
              rule.param_comparison_value
            )
            .patient_requires_test?
        end

        def rules
          GlobalRule.where(regime: @regime)
        end
      end
    end
  end
end
