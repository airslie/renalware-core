module Renalware
  module Patients
    module ODS
      module DSE
        describe RowCountPolicy do
          it "uses the fixed minimum when there is no previous source count" do
            minimum = described_class.new.minimum_for(:practices, fixed_minimum: 10_000)

            expect(minimum).to eq(10_000)
          end

          it "allows at most a 15 percent decrease from the previous successful count" do
            create(
              :api_log,
              identifier: described_class::API_LOG_IDENTIFIER,
              values: ["source_rows_practices=20000"]
            )

            minimum = described_class.new.minimum_for(:practices, fixed_minimum: 10_000)

            expect(minimum).to eq(17_000)
          end

          it "does not use dry-run counts as the production baseline" do
            create(
              :api_log,
              identifier: described_class::API_LOG_IDENTIFIER,
              dry_run: true,
              values: ["source_rows_practices=20000"]
            )

            minimum = described_class.new.minimum_for(:practices, fixed_minimum: 10_000)

            expect(minimum).to eq(10_000)
          end
        end
      end
    end
  end
end
