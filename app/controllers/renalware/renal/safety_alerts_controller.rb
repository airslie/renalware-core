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
        alerts = filtered_alerts(relation.with_patient_and_rule.ordered)
        authorize alerts

        pagy, alerts = pagy(alerts)
        render locals: {
          alerts: alerts,
          categories: Renal::SafetyAlertRuleCategory.ordered,
          grouped_rule_options: Renal::SafetyAlertRule.grouped_options_for_select,
          historical: historical,
          pagy: pagy,
          selected_category_id: selected_category_id,
          selected_rule_id: selected_rule_id
        }
      end

      def alert
        @alert ||= SafetyAlert.find(params[:id]).tap { |alert| authorize alert }
      end

      def safety_alert_params
        params.fetch(:renal_safety_alert, ActionController::Parameters.new).permit(:notes)
      end

      def filtered_alerts(scope)
        scope
          .then { |relation| filter_by_category(relation) }
          .then { |relation| filter_by_rule(relation) }
      end

      def filter_by_category(scope)
        return scope if selected_category_id.blank?

        scope
          .joins(:safety_alert_rule)
          .where(
            renal_safety_alert_rules: {
              safety_alert_rule_category_id: selected_category_id
            }
          )
      end

      def filter_by_rule(scope)
        return scope if selected_rule_id.blank?

        scope.where(safety_alert_rule_id: selected_rule_id)
      end

      def selected_category_id
        params[:safety_alert_rule_category_id].presence
      end

      def selected_rule_id
        params[:safety_alert_rule_id].presence
      end
    end
  end
end
