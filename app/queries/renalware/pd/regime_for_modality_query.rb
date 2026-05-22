module Renalware
  module PD
    class RegimeForModalityQuery
      pattr_initialize [:modality!, look_ahead_days: 14]

      def call
        active_regime || first_regime_created_soon_after_modality_start
      end

      private

      def active_regime
        regimes
          .where(start_date: ..modality.started_on)
          .where("end_date IS NULL OR end_date > ?", modality.started_on)
          .order(start_date: :desc, created_at: :desc)
          .first
      end

      def first_regime_created_soon_after_modality_start
        regimes
          .where(start_date: (modality.started_on + 1.day)..latest_look_ahead_date)
          .order(start_date: :asc, created_at: :desc)
          .first
      end

      def regimes
        Regime.where(patient_id: modality.patient_id)
      end

      def latest_look_ahead_date
        modality.started_on + look_ahead_days.days
      end
    end
  end
end
