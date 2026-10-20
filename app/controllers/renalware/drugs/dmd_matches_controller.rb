module Renalware
  module Drugs
    class DMDMatchesController < BaseController
      def index
        authorize DMDMatch

        dmd_matches_search = DMDMatch.ransack(params.fetch(:q, {}))
        dmd_matches_search.sorts = "drug_name" if dmd_matches_search.sorts.empty?
        respond_to do |format|
          format.html { render_matches(dmd_matches_search) }
          format.csv do
            send_data DMDMigration::MatchExport.new.call(dmd_matches_search.result),
                      filename: "dmd-matches-#{Date.current.iso8601}.csv",
                      type: "text/csv; charset=utf-8",
                      disposition: "attachment"
          end
        end
      end

      def new
        authorize DMDMatch

        form = DMDMigration::MatchImport.new

        render locals: { form: form }
      end

      def create
        authorize DMDMatch

        form = DMDMigration::MatchImport.new(import_params)

        if form.save
          action = form.validate_only ? "Validated" : "Imported"
          notice = "#{action} #{form.imported_count} mappings. Prescriptions are unchanged."
          redirect_to drugs_dmd_matches_path, notice: notice
        else
          render :new, locals: { form: form }, status: :unprocessable_content
        end
      end

      private

      def render_matches(dmd_matches_search)
        pagy, dmd_matches = pagy(dmd_matches_search.result)
        render locals: { dmd_matches: dmd_matches,
                         dmd_matches_search: dmd_matches_search,
                         pagy: pagy }
      end

      def import_params
        key = DMDMigration::MatchImport.model_name.param_key
        params.fetch(key, ActionController::Parameters.new).permit(:file, :validate_only)
      end
    end
  end
end
