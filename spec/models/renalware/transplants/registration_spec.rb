require "rails_helper"

module Renalware
  module Transplants
    describe Registration do
      let(:registration) { create(:transplant_registration, :with_statuses) }
      let(:earliest_status) { registration.statuses.order("created_at ASC").first }
      let(:latest_status) { registration.statuses.order("created_at DESC").first }

      it { should accept_nested_attributes_for(:statuses) }

      describe "#update_attributes" do
        context "when creating the registration" do
          let(:patient) { create(:patient) }
          let(:status_description) { create(:transplant_registration_status_description) }

          it "creates the status at the same time" do
            params = {
              patient_id: patient.id,
              statuses_attributes: {
                "0": {
                  started_on: "03-11-2015",
                  description_id: status_description.id
                }
              }
            }

            registration = Registration.new
            registration.update_attributes(params)
            expect(registration).to be_persisted
            expect(registration.statuses.count).to eq(1)
          end
        end
      end

      describe "#current_status" do
        it "returns the status not terminated" do
          expect(registration.current_status).to eq(latest_status)
        end
      end

      describe "#add_status!" do
        it "returns the new status" do
          status = registration.add_status!(started_on: Time.zone.today)
          expect(status).to be_a(RegistrationStatus)
        end

        it "terminates the current status" do
          status = registration.current_status

          registration.add_status!(started_on: Time.zone.today)

          expect(status.reload).to be_terminated
        end

        it "recomputes the termination dates" do
          expect(registration).to receive(:recompute_termination_dates!)

          registration.add_status!(started_on: 3.days.ago)
        end

        it "returns status with errors if not valid" do
          status = registration.add_status!({})

          expect(status).to_not be_valid
        end
      end

      describe "#update_status!" do
        it "returns the updated status" do
          status = registration.update_status!(earliest_status, {})

          expect(status).to be_a(RegistrationStatus)
        end

        it "updates the status with given parameters" do
          datestamp = earliest_status.started_on + 1.day

          registration.update_status!(earliest_status, started_on: datestamp)

          expect(earliest_status.reload.started_on).to eq(datestamp)
        end

        it "recomputes the termination dates" do
          expect(registration).to receive(:recompute_termination_dates!)

          registration.update_status!(
            earliest_status,
            started_on: earliest_status.started_on + 1.day
          )
        end
      end

      describe "#delete_status!" do
        it "updates the status with given parameters" do
          registration.delete_status!(earliest_status)

          expect(registration.statuses.where(id: earliest_status.id).exists?).to be_falsy
        end

        it "recomputes the termination dates" do
          expect(registration).to receive(:recompute_termination_dates!)

          registration.delete_status!(earliest_status)
        end
      end
    end
  end
end