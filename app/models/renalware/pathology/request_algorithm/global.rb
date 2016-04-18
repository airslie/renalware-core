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
          rules
            .select do |rule|
              GlobalRuleDecider.new(@patient, rule).observation_required?
            end
            .map { |rule| rule.observation_description_id }
            .uniq
        end

        private

        def rules
          GlobalRule.where(regime: @regime)
        end
      end
    end
  end
end
