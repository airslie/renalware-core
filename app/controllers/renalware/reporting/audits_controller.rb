require_dependency "renalware/reporting"

module Renalware
  module Reporting
    class AuditsController < BaseController
      include PresenterHelper

      def index
        authorize Audit, :index?
        render locals: { audits: present(Audit.all, AuditPresenter) }
      end

      def show
        authorize audit
        columns, values = GenerateAuditJson.call(audit.materialized_view_name)
        render(
          locals: {
            audit: audit,
            columns: columns,
            values: values
          }
        )
      end

      def edit
        authorize audit
        render_edit
      end

      def update
        authorize audit
        if audit.update(audit_params)
          redirect_to reporting_audits_path, notice: success_msg_for("audit")
        else
          render_edit
        end
      end

      private

      def audit
        @audit ||= Audit.find(params[:id])
      end

      def render_edit
        render :edit, locals: {
          audit: audit,
          available_data_sources: Renalware::Reporting::Audit.available_audit_materialized_views
        }
      end

      def audit_params
        params.require(:reporting_audit)
              .permit(
                :name,
                :description,
                :materialized_view_name,
                :display_configuration,
                :refresh_schedule
              )
      end
    end
  end
end
