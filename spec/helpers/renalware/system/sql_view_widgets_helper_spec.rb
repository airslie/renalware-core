module Renalware
  module System
    describe SqlViewWidgetsHelper do
      describe "#sql_view_widgets_for" do
        it "renders async frames outside Lab contexts" do
          widget = create(
            :view_metadata,
            category: :widget,
            schema_name: "site",
            view_name: "generic_patient_widget_view",
            title: "Generic Patient Widget",
            widget_options: {
              slots: ["hd_mdm:middle"],
              async: true
            }
          )
          allow(helper)
            .to receive(:render_sql_view_widget_placeholder)
            .and_return("Loading")

          html = helper.sql_view_widgets_for("hd_mdm:middle")

          expect(html).to include(%(id="sql-view-widget-#{widget.id}"))
          expect(html).to include(%(src="/system/sql_view_widgets/#{widget.id}))
          expect(html).to include("schema_name=site")
          expect(html).to include("slot=hd_mdm%3Amiddle")
          expect(html).to include("Loading")
        end
      end
    end
  end
end
