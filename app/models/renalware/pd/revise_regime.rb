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

      # rubocop:disable Metrics/AbcSize
      # temp disable
      def call(by:, params:)
        Regime.transaction do
          regime.assign_attributes(params)

          return Success.new(regime: regime) unless regime.anything_changed?
          return Failure.new(regime: regime.with_bag_destruction_marks_removed) unless regime.valid?

          new_regime = duplicate_original_regime
          terminate_original_regime(by: by, new_regime: new_regime)

          Success.new(regime: new_regime)
        end
      rescue ValidationFailedError
        Failure.new(regime: regime.with_bag_destruction_marks_removed)
      end
      # rubocop:enable Metrics/AbcSize

      class ValidationFailedError < StandardError
      end

      private

      def duplicate_original_regime
        new_regime = regime.deep_dup
        new_regime.save!
        new_regime
      end

      # rubocop:disable Metrics/AbcSize
      def terminate_original_regime(by:, new_regime:)
        regime.deep_restore_attributes
        if regime.start_date > new_regime.start_date
          regime.errors.add(:start_date, "must be later than previous regime it is preceding")
          raise ValidationFailedError
        else
          regime.end_date ||= new_regime.start_date
          regime.terminate(by: by)
          regime.save!
        end
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
