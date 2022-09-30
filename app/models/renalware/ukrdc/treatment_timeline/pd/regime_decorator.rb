# frozen_string_literal: true

module Renalware
  module UKRDC
    module TreatmentTimeline
      module PD
        class RegimeDecorator < DumbDelegator
          def initialize(regime, last_regime:)
            @last_regime = last_regime
            super(regime)
          end

          def changed?
            return true if last_regime.blank?

            regime_type_changed?
          end

          def regime_type_changed?
            last_regime&.type != type
          end

          def unchanged?
            !changed?
          end

          private

          attr_reader :last_regime
        end
      end
    end
  end
end
