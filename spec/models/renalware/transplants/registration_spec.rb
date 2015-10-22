require 'rails_helper'

module Renalware
  module Transplants
    describe Registration do
      let(:registration) { create(:transplant_registration, :with_statuses) }
      let(:earliest_status) { registration.statuses.order('created_at ASC').first }
      let(:latest_status) { registration.statuses.order('created_at DESC').first }

      describe "#current_status" do
        it "returns the status not terminated" do
          expect(registration.current_status).to eq(latest_status)
        end
      end

      describe "#add_status" do
        it "terminates the current status" do
          status = registration.current_status

          registration.add_status(started_on: Date.today)

          expect(status.reload).to be_terminated
        end

        it "recomputes the termination dates" do
          expect(registration).to receive(:recompute_termination_dates!)

          registration.add_status(started_on: 3.days.ago)
        end
      end

      describe "#update_status" do
        it "updates the status with given parameters" do
          datestamp = earliest_status.started_on + 1.day

          registration.update_status(earliest_status, started_on: datestamp)

          expect(earliest_status.reload.started_on).to eq(datestamp)
        end

        it "recomputes the termination dates" do
          expect(registration).to receive(:recompute_termination_dates!)

          registration.update_status(earliest_status, started_on: earliest_status.started_on + 1.day)
        end
      end

      describe "#delete_status" do
        it "updates the status with given parameters" do
          registration.delete_status(earliest_status)

          expect(registration.statuses.where(id: earliest_status.id).exists?).to be_falsy
        end

        it "recomputes the termination dates" do
          expect(registration).to receive(:recompute_termination_dates!)

          registration.delete_status(earliest_status)
        end
      end
    end
  end
end