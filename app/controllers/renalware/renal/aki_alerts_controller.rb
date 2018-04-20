# frozen_string_literal: true

require_dependency("renalware/renal")

module Renalware
  module Renal
    class AKIAlertsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        query = search_form.query
        alerts = query.call.page(page).per(per_page)
        authorize alerts
        render locals: {
          alerts: alerts,
          form: search_form,
          search: query.search,
          path_params: path_params
        }
      end

      def edit
        authorize alert
        render_edit(alert)
      end

      def update
        authorize alert
        if alert.update(aki_alert_params.merge(by: current_user))
          redirect_to renal_filtered_aki_alerts_path(named_filter: :today)
        else
          render_edit(alert)
        end
      end

      private

      def search_form
        @search_form ||= begin
          options = params.key?(:q) ? search_params : {}
          options[:named_filter] = named_filter
          AKIAlertSearchForm.new(options)
        end
      end

      def render_edit(alert)
        render :edit, locals: { alert: alert }
      end

      def alert
        @alert ||= AKIAlert.find(params[:id])
      end

      def aki_alert_params
        params
          .require(:renal_aki_alert)
          .permit(
            :notes, :action_id, :hotlist, :hospital_ward_id,
            :max_cre, :cre_date, :max_aki, :aki_date
          )
      end

      def search_params
        params
          .require(:q) {}
          .permit(:term, :on_hotlist, :action, :hospital_unit_id, :hospital_ward_id, :s)
      end

      def path_params
        params.permit([:controller, :action, :named_filter])
      end

      def named_filter
        params[:named_filter]
      end
    end
  end
end
