module Renalware
  module HD
    describe GenerateMonthlyStatisticsForPatientJob do
      subject(:job) { described_class.new }

      let(:patient) { build_stubbed(:hd_patient) }
      let(:month) { 12 }
      let(:year) { 2016 }

      it { is_expected.to respond_to(:queue_name) }

      describe "#perform" do
        it "delegates to a service object passing in last month" do
          service = instance_double(GenerateMonthlyStatisticsForPatient, call: nil)
          allow(GenerateMonthlyStatisticsForPatient).to receive(:new).and_return(service)

          job.perform(patient:, month:, year:)

          expect(GenerateMonthlyStatisticsForPatient)
            .to have_received(:new).with(patient:, period: having_attributes(month:, year:))
          expect(service).to have_received(:call).once
        end
      end
    end
  end
end
