module Renalware
  module Reporting
    describe "renalware/reporting/reports/_filters.html.slim" do
      let(:view_klass) { SqlView.new("renalware.transplant_mdm_patients").klass }
      let(:search) { view_klass.ransack({}) }
      let(:current_view) do
        instance_double(
          System::ViewMetadata,
          filters: [
            System::FilterDefinition.new(code: :sex, type: :multi)
          ],
          view_name: "transplant_mdm_patients"
        )
      end
      let(:options) do
        ReportsController::ReportOptions.new(
          search:,
          rows: [],
          current_view:,
          pagination: nil,
          report_path_without_params: "/reports/1/content",
          reset_path: "/reports/1",
          report_csv_download_path_with_params: "/reports/1.csv"
        )
      end

      it "renders multi-select filters using the Ransack in predicate and SlimSelect" do
        relation = instance_double(ActiveRecord::Relation)
        allow(view_klass).to receive(:distinct).with(:sex).and_return(relation)
        allow(relation).to receive(:pluck).with(:sex).and_return(%w(F M))

        render partial: "renalware/reporting/reports/filters", locals: { options: }

        expect(rendered).to have_css(
          "select[name='q[sex_in][]'][multiple='multiple']" \
          "[data-controller='slimselect'][data-action='change->form#submit']"
        )
        expect(rendered).to have_css("option[value='F']", text: "F")
        expect(rendered).to have_css("option[value='M']", text: "M")
      end
    end
  end
end
