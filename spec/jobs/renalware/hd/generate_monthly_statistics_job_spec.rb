# frozen_string_literal: true

require "rails_helper"
require "delayed_job_active_record"

module Renalware
  module HD
    describe GenerateMonthlyStatisticsJob, type: :job do
      subject(:job) { described_class.new }

      it { is_expected.to respond_to(:queue_name) }

      describe "#perform" do
        it "enqueues a job per patient (that spawned job will actually generate the stats)" do
          patient = create(:hd_patient)

          travel_to Date.new(2017, 02, 01) do
            create(:hd_closed_session, patient: patient, signed_off_at: Time.zone.now - 1.month)
            expect(GenerateMonthlyStatisticsForPatientJob).to receive(:perform_later).exactly(:once)

            job.perform
          end
        end
      end
    end
  end
end
