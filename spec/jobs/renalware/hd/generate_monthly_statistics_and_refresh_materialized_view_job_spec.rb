module Renalware
  module HD
    describe GenerateMonthlyStatisticsAndRefreshMaterializedViewJob do
      let(:monthly_statistics) { instance_double(GenerateMonthlyStatistics, call: nil) }
      let(:perform) { -> { described_class.perform_now } }

      before do
        allow(GenerateMonthlyStatistics)
          .to receive(:new).with(month: nil, year: nil)
          .and_return monthly_statistics
      end

      describe "#perform" do
        it "delegates to a service object passing in last month" do
          expect(perform).to have_enqueued_job(RefreshMaterializedViewJob)

          expect(monthly_statistics).to have_received(:call)
        end
      end
    end
  end
end
