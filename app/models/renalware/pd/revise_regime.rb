require_dependency "renalware/pd"

module Renalware
  module PD
    class ReviseRegime
      attr_reader :regime

      class Result
        include Virtus::Model
        attribute :regime, Regime

        def success?
          false
        end
      end

      class Failure < Result
      end

      class Success < Result
        def success?
          true
        end
      end

      def initialize(regime)
        @regime = regime
      end

      def call(params)
        regime.assign_attributes(params)

        return Success.new(regime: regime) unless regime.anything_changed?
        return Failure.new(regime: regime.with_bag_destruction_marks_removed) unless regime.valid?

        new_regime = regime.deep_dup
        new_regime.save!

        regime.deep_restore_attributes

        Success.new(regime: new_regime)
      end
    end
  end
end
