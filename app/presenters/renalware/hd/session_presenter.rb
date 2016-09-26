module Renalware
  module HD
    class SessionPresenter < DumbDelegator
      attr_reader :preference_set
      delegate :info,
               :observations_before,
               :observations_after,
               :dialysis,
               to: :document
      delegate :access_site,
               :machine_no,
               to: :info
      delegate :arterial_pressure,
               :venous_pressure,
               :blood_flow,
               :fluid_removed,
               :litres_processed,
               :machine_urr,
               :machine_ktv,
               to: :dialysis

      def ongoing_css_class
        "active" unless signed_off?
      end

      def performed_on
        ::I18n.l(super)
      end

      def start_time
        ::I18n.l(super, format: :time)
      end

      def end_time
        ::I18n.l(super, format: :time)
      end

      def duration
        super && Duration.from_minutes(super)
      end

      def pre(measurement)
        observations_before.send(measurement.to_sym)
      end

      def post(measurement)
        observations_after.send(measurement.to_sym)
      end
    end
  end
end
