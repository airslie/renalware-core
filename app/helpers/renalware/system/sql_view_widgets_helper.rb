module Renalware
  module System
    module SqlViewWidgetsHelper
      def sql_view_widgets_for(
        slot,
        patient: nil,
        patient_scope: nil,
        lab: false,
        schema_name: nil,
        require_patient_scope: false
      )
        widgets = Renalware::System::ViewMetadata.for_widget_slot(slot)
        widgets = widgets.where(schema_name: schema_name) if schema_name.present?
        widgets = widgets.order(:position)

        safe_join(
          widgets.map do |view_metadata|
            if async_sql_view_widget?(view_metadata)
              async_sql_view_widget_frame(
                view_metadata,
                patient: patient,
                schema_name: schema_name,
                slot: slot
              )
            else
              render_sql_view_widget(
                view_metadata,
                lab: lab,
                patient: patient,
                patient_scope: patient_scope,
                require_patient_scope: require_patient_scope
              )
            end
          end
        )
      end

      private

      def async_sql_view_widget?(view_metadata)
        view_metadata.persisted? && view_metadata.widget_options.async?
      end

      def async_sql_view_widget_frame(
        view_metadata,
        patient:,
        schema_name:,
        slot:
      )
        turbo_frame_tag(
          sql_view_widget_frame_id(view_metadata),
          src: system_sql_view_widget_path(
            view_metadata,
            patient_id: patient&.to_param,
            schema_name: schema_name.presence || view_metadata.schema_name,
            slot: slot
          ),
          loading: :lazy
        ) do
          render_sql_view_widget_placeholder(view_metadata)
        end
      end

      def render_sql_view_widget_placeholder(view_metadata)
        component = Renalware::ArticleComponent.new(classes: "system-sql-view-widget simple")

        render(component) do |article|
          article.with_title { view_metadata.title.presence || view_metadata.view_name.humanize }

          render Renalware::SpinnerComponent.new do |spinner|
            spinner.with_main_content do
              content_tag(:p, "Loading...")
            end
          end
        end
      end

      def render_sql_view_widget(
        view_metadata,
        lab:,
        patient:,
        patient_scope:,
        require_patient_scope:
      )
        Renalware::System::SqlViewWidgetRenderer.new(
          view_metadata: view_metadata,
          view_context: self,
          lab: lab,
          patient: patient,
          patient_scope: patient_scope,
          require_patient_scope: require_patient_scope
        ).call
      end

      def sql_view_widget_frame_id(view_metadata)
        "sql-view-widget-#{view_metadata.id}"
      end
    end
  end
end
