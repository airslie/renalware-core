module Renalware
  module Pathology
    class RequestAlgorithm
      class GlobalRuleDecider
        def initialize(patient, rule)
          @patient = patient
          @rule = rule
        end

        def observation_required?
          observation_required_from_param? && observation_required_from_frequency?
        end

        private

        def observation_required_from_param?
          return true unless @rule.has_param?

          param_type_class =
            "::Renalware::Pathology::RequestAlgorithm::ParamType::#{@rule.param_type}"
            .constantize

          param_type_class
            .new(
              @patient,
              @rule.param_id,
              @rule.param_comparison_operator,
              @rule.param_comparison_value
            )
            .patient_requires_test?
        end

        def observation_required_from_frequency?
          return true if last_observation.nil?
          #days_ago_observed = (Time.now - last_observation.observed_at) / (24*60*60)
          days_ago_observed = Date.today - last_observation.observed_at.to_date

          # TODO: Implement other frequency types (3Monthly, Yearly etc.)
          if @rule.frequency == "Always"
            true
          elsif @rule.frequency == "Once"
            false
          elsif @rule.frequency == "Weekly"
            days_ago_observed >= 7
          elsif @rule.frequency == "Monthly"
            days_ago_observed >= 28
          end
        end

        def last_observation
          @last_observation ||=
            Renalware::Pathology.cast_patient(@patient)
              .observations.where(description_id: @rule.observation_description_id)
              .order(observed_at: :desc).limit(1).first
        end
      end
    end
  end
end
