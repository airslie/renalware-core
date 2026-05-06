module Renalware
  module Renal
    class SafetyAlertsController < BaseController
      def index
        render_collection(SafetyAlert.active, historical: false)
      end

      def historical
        render_collection(SafetyAlert.resolved, historical: true)
      end

      def update
        if alert.resolved?
          redirect_to(
            historical_renal_safety_alerts_path,
            alert: "Resolved safety alerts cannot be updated"
          )
          return
        end

        alert.update!(safety_alert_params)
        redirect_to renal_safety_alerts_path, notice: "Safety alert updated"
      end

      def resolve
        if alert.resolved?
          redirect_to historical_renal_safety_alerts_path, alert: "Safety alert is already resolved"
          return
        end

        alert.resolve!(by: current_user, notes: safety_alert_params[:notes])
        redirect_to renal_safety_alerts_path, notice: "Safety alert resolved"
      end

      private

      def render_collection(relation, historical:)
        alerts = relation.with_patient_and_rule.ordered
        authorize alerts

        pagy, alerts = pagy(alerts)
        render locals: { alerts: alerts, historical: historical, pagy: pagy }
      end

      def alert
        @alert ||= SafetyAlert.find(params[:id]).tap { |alert| authorize alert }
      end

      def safety_alert_params
        params.fetch(:renal_safety_alert, ActionController::Parameters.new).permit(:notes)
      end
    end
  end
end
