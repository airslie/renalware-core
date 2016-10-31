require "rails_helper"

module Renalware::HD
  RSpec.describe ReviseHDProfile do
    let(:patient) { create(:hd_patient) }

    let(:original_profile) do
      create(:hd_profile, patient: patient)
    end

    describe "#call" do
      let(:user) { create(:user) }

      context "updating the profile other_schedule with a valid value" do
        let(:other_schedule) { "Mon Fri Sun" }

        subject!(:revision) do
          ReviseHDProfile.new(original_profile).call(other_schedule: other_schedule, by: user)
        end

        it "returns true" do
          expect(revision).to be(true)
        end

        context "when nothing has changed" do
          let(:other_schedule) { original_profile.other_schedule }

          it "does not create a new profile" do
            expect(Profile.count).to eq(1)
          end
        end

        context "when something has changed" do
          it "creates a new profile" do
            expect(Profile.count).to eq(2)
          end
        end

        it "terminates the original prescription and creates a new one" do
          pending
          expect(patient.hd_profiles.count).to eq(2)
        end

        it "create a new prescription with the specified dose amount" do
          pending
          expect(patient.prescriptions.current.first.dose_amount).to eq(revised_dose_amount)
        end

        it "retains the original other_schedule on the deactivated profile" do
          pending
          expect(patient.prescriptions.terminated.first.dose_amount).to eq(original_dose_amount)
        end
      end

      context "updating the with an invalid value" do
        let(:revised_prescriber) { nil }

        subject!(:revision) do
          ReviseHDProfile.new(original_profile)
                         .call(prescriber: revised_prescriber, by: user)
        end

        it "returns false" do
          expect(revision).to eq(false)
        end

        it "populates the original profile's errors" do
          expect(original_profile.errors.messages.keys).to include(:prescriber)
        end

        it "sets the original profile's value to the revised value" do
          expect(original_profile.prescriber).to eq(revised_prescriber)
        end

        it "rolls back the transaction" do
          expect(Profile.count).to eq(1)
          expect(Profile.first).to eq(original_profile)
        end
      end
    end
  end
end
