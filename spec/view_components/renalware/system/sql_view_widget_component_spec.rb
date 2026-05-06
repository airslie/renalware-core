module Renalware
  module System
    describe SqlViewWidgetComponent, type: :component do
      let(:view_metadata) {
        build(
          :view_metadata,
          category: :widget,
          schema_name: "renalware",
          view_name: "sql_view_widget_component_test_view",
          title: "Test Results",
          columns: [
            ColumnDefinition.new(code: "patient_id", hidden: true),
            ColumnDefinition.new(code: "performed_on", name: "Date"),
            ColumnDefinition.new(code: "test_type", name: "Type")
          ],
          widget_options: widget_options
        )
      }

      let(:widget_options) {
        {
          max_rows: 2,
          order_by: "performed_on",
          order_direction: "desc",
          empty_state: "No test data"
        }
      }

      before do
        connection = ApplicationRecord.connection
        connection.execute(<<~SQL.squish)
          CREATE TABLE IF NOT EXISTS renalware.sql_view_widget_component_test_rows (
            patient_id bigint,
            performed_on date,
            test_type text
          )
        SQL
        connection.execute(<<~SQL.squish)
          CREATE OR REPLACE VIEW renalware.sql_view_widget_component_test_view AS
          SELECT patient_id, performed_on, test_type
          FROM renalware.sql_view_widget_component_test_rows
        SQL
        connection.execute(
          "DELETE FROM renalware.sql_view_widget_component_test_rows"
        )
        connection.execute(<<~SQL.squish)
          INSERT INTO renalware.sql_view_widget_component_test_rows
            (patient_id, performed_on, test_type)
          VALUES
            (1, '2026-05-01', 'UKM'),
            (1, '2026-05-03', 'Kt/V'),
            (2, '2026-05-02', 'Other')
        SQL
      end

      after do
        connection = ApplicationRecord.connection
        connection.execute("DROP VIEW IF EXISTS renalware.sql_view_widget_component_test_view")
        connection.execute("DROP TABLE IF EXISTS renalware.sql_view_widget_component_test_rows")
      end

      it "renders a compact table from a SQL view" do
        render_inline(described_class.new(view_metadata: view_metadata))

        expect(page).to have_text("Test Results")
        expect(page).to have_text("Date")
        expect(page).to have_text("Type")
        expect(page).to have_text("Kt/V")
        expect(page).to have_text("Other")
        expect(page).to have_no_text("UKM")
      end

      context "when scoped to a patient" do
        let(:patient) { instance_double(Patient, id: 1) }

        let(:widget_options) {
          super().merge(patient_id_column: "patient_id", max_rows: 5)
        }

        it "only renders rows for the supplied patient" do
          render_inline(described_class.new(view_metadata: view_metadata, patient: patient))

          expect(page).to have_text("Kt/V")
          expect(page).to have_text("UKM")
          expect(page).to have_no_text("Other")
        end

        it "does not render global rows when no patient is supplied" do
          render_inline(described_class.new(view_metadata: view_metadata))

          expect(page).to have_text("No test data")
          expect(page).to have_no_text("Kt/V")
          expect(page).to have_no_text("Other")
        end
      end
    end
  end
end
