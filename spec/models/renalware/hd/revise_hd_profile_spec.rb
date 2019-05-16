# frozen_string_literal: true

require "rails_helper"

module Renalware::HD
  describe ReviseHDProfile do
    let(:patient) { create(:hd_patient) }

    let(:original_profile) do
      create(:hd_profile, patient: patient, other_schedule: nil, by: user)
    end

    describe "#call" do
      let(:user) { create(:user) }

      it "raises an error if the supplied profile is new and not persisted" do
        expect {
          ReviseHDProfile.new(Profile.new)
        }.to raise_error(ArgumentError)
      end

      context "when updating the profile other_schedule with a valid value" do
        subject!(:revised_profile) do
          ReviseHDProfile.new(original_profile)
            .call(other_schedule: other_schedule, by: another_user)
        end

        let(:another_user) { create(:user) }

        let(:other_schedule) { "Mon Fri Sun" }

        it "returns a profile" do
          expect(revised_profile).to be_present
        end

        it "saves the user making the change in updated_by_id" do
          expect(original_profile.updated_by).to eq(user)
          expect(revised_profile.reload.updated_by).to eq(another_user)
        end

        context "when nothing has changed" do
          let(:other_schedule) { original_profile.other_schedule }

          it "returns true" do
            expect(revised_profile).to be(true)
          end

          it "does not create a new profile" do
            expect(Profile.count).to eq(1)
          end
        end

        context "when something has changed" do
          it "creates a new active profile assigned to the patient" do
            expect(Profile.for_patient(patient).count).to eq(1)
            active_profile = Profile.for_patient(patient).first
            expect(active_profile.id).not_to eq(original_profile.id)
            expect(active_profile.active).to eq(true)
            expect(active_profile.deactivated_at).to be_nil
            expect(active_profile.patient_id).to eq(patient.id)
          end

          it "can access the active profile through the patient" do
            expect(patient.hd_profile).to eq(Profile.for_patient(patient).first)
          end

          it "updates the value on the new profile" do
            active_profile = Profile.for_patient(patient).first
            expect(active_profile.other_schedule).to eq(other_schedule)
          end

          it "marks the original profile as inactive" do
            expect(Profile.with_deactivated.count).to eq(2)
            original_profile.reload
            expect(original_profile.active).to eq(nil)
            expect(original_profile.deactivated_at).not_to be_nil
            expect(original_profile.patient_id).to eq(patient.id)
          end

          it "retains the old value on the original profile" do
            expect(original_profile.reload.other_schedule).to eq(nil)
          end
        end
      end

      context "when updating with an invalid value" do
        subject!(:revised_profile) do
          ReviseHDProfile.new(original_profile)
                         .call(prescriber: revised_prescriber, by: user)
        end

        let(:revised_prescriber) { nil }

        it "returns false" do
          expect(revised_profile).to eq(false)
        end

        it "populates the original profile's errors" do
          expect(original_profile.errors.messages.keys).to include(:prescriber)
        end

        it "sets the original profile's value to the revised value" do
          expect(original_profile.prescriber).to eq(revised_prescriber)
        end

        it "does not save a new profile" do
          expect(Profile.count).to eq(1)
          expect(Profile.first).to eq(original_profile)
          active_profile = Profile.for_patient(patient).first
          expect(active_profile).to eq(original_profile)
        end
      end
    end
  end
end
