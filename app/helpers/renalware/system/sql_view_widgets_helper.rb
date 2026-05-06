module Renalware
  module System
    module SqlViewWidgetsHelper
      def sql_view_widgets_for(slot, patient: nil)
        widgets = Renalware::System::ViewMetadata.for_widget_slot(slot).order(:position)

        safe_join(
          widgets.map do |view_metadata|
            render(
              Renalware::System::SqlViewWidgetComponent.new(
                view_metadata: view_metadata,
                patient: patient,
                current_user: current_user
              )
            )
          end
        )
      end
    end
  end
end
