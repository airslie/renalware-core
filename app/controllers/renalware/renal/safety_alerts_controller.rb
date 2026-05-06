module Renalware
  module Renal
    class SafetyAlertsController < BaseController
      def index
        render_collection(SafetyAlert.active, historical: false)
      end

      def historical
        render_collection(SafetyAlert.resolved, historical: true)
      end

      def destroy
        alert.resolve!
        redirect_to renal_safety_alerts_path, notice: success_msg_for("safety alert")
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
    end
  end
end
