require "rails_helper"

module Renalware
  module HD
    describe GenerateMonthlyStatisticsJob, type: :job do
      it { is_expected.to respond_to(:queue_name) }

      describe "#perform" do
        it "delegates to a service object passing in last month" do

          patient = create(:hd_patient)

          travel_to Date.new(2017, 02, 01) do
            create(:hd_closed_session, patient: patient, signed_off_at: Time.now - 1.month)

            expect{ subject.perform }.to change{ Delayed::Job.count }.by(1)
          end
        end
      end
    end
  end
end
