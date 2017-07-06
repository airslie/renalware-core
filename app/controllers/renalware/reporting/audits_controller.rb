require_dependency "renalware/reporting"

module Renalware
  module Reporting
    class AuditsController < BaseController

      def index
        authorize Audit, :index?
        render locals: { audits: Audit.all }
      end

      def show
        authorize audit

        respond_to do |format|
          format.json { render(json: audit_json) && return }
          format.html { render(locals: { audit: audit }) }
        end
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

      # Convert a PGResult into a hash DataTables can understand
      def audit_json
        GenerateAuditJson.call(audit.materialized_view_name)
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
