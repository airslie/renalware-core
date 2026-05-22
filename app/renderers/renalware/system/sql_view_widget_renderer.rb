module Renalware
  module System
    class SqlViewWidgetRenderer
      class PatientScopeRequiredError < StandardError; end

      attr_reader :current_user,
                  :lab,
                  :patient,
                  :patient_scope,
                  :require_patient_scope,
                  :view_context,
                  :view_metadata

      delegate :content_tag, :render, :safe_join, to: :view_context

      def initialize(
        view_metadata:,
        view_context:,
        lab: false,
        patient: nil,
        patient_scope: nil,
        require_patient_scope: false
      )
        @view_metadata = view_metadata
        @view_context = view_context
        @current_user = view_context.current_user
        @lab = lab == true
        @patient = patient
        @patient_scope = patient_scope
        @require_patient_scope = require_patient_scope
      end

      def call
        return render_widget unless lab

        render_widget
      rescue StandardError => e
        log_error(e)
        render_error(e)
      end

      private

      def render_widget
        validate_patient_scoped_widget! if require_patient_scope
        record_view_call

        render(
          Renalware::System::SqlViewWidgetComponent.new(
            view_metadata: view_metadata,
            patient: patient,
            patient_scope: patient_scope,
            current_user: current_user
          )
        )
      end

      def validate_patient_scoped_widget!
        return if view_metadata.widget_options.patient_id_column.present?

        raise(
          PatientScopeRequiredError,
          "Patient lab widgets must define widget_options.patient_id_column"
        )
      end

      def record_view_call
        return if !lab || current_user.blank?

        view_metadata.calls.create!(user: current_user, called_at: Time.zone.now)
      end

      def log_error(error)
        Rails.logger.error(
          "Failed to render SQL view widget " \
          "#{view_metadata.fully_qualified_view_name}: " \
          "#{error.class}: #{error.message}"
        )
      end

      def render_error(error)
        component = Renalware::ArticleComponent.new(
          classes: "system-sql-view-widget simple"
        )

        render(component) do |article|
          article.with_title { title }

          if display_debug_error?
            safe_join(
              [
                content_tag(:p, "This Lab item could not be loaded."),
                content_tag(:pre, "#{error.class}: #{error.message}")
              ]
            )
          else
            content_tag(:p, "This Lab item could not be loaded.")
          end
        end
      end

      def title
        view_metadata.title.presence || view_metadata.view_name.humanize
      end

      def display_debug_error?
        Rails.env.development? ||
          Renalware.stage.uat? ||
          (Renalware.stage.production? && current_user&.has_role?(:super_admin))
      end
    end
  end
end
