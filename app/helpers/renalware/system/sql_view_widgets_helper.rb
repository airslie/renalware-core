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
            Renalware::System::SqlViewWidgetRenderer.new(
              view_metadata: view_metadata,
              view_context: self,
              lab: lab,
              patient: patient,
              patient_scope: patient_scope,
              require_patient_scope: require_patient_scope
            ).call
          end
        )
      end
    end
  end
end
