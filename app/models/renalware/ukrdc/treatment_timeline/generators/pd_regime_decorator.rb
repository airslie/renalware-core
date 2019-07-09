# frozen_string_literal: true

require_dependency "renalware/ukrdc"
require "attr_extras"

module Renalware
  module UKRDC
    module TreatmentTimeline
      module Generators
        class PDRegimeDecorator < DumbDelegator
          def initialize(regime, last_regime:)
            @last_regime = last_regime
            super(regime)
          end

          def changed?
            return true if last_regime.blank?

            regime_type_changed?
          end

          def regime_type_changed?
            last_regime&.type != regime.type
          end

          def unchanged?
            !changed?
          end

          private

          attr_reader :last_profile
        end
      end
    end
  end
end
