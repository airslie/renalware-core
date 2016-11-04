require "rails_helper"

module Renalware
  module HD
    describe GenerateMonthlyPatientStatisticsJob, type: :job do
      it { is_expected.to respond_to(:queue_name) }

      describe "#perform" do
        it "delegates to a service object passing in last month" do
          travel_to Date.new(2017, 01, 01)
          expect_any_instance_of(GenerateMonthlyPatientStatistics)
            .to receive(:call)
            .with(month: 12, year: 2016) # today - 1.month

          subject.perform
        end
      end
    end
  end
end
