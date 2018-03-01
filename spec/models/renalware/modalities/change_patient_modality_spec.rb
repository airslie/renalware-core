# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
require "rails_helper"

module Renalware
  RSpec.describe Modalities::ChangePatientModality, type: :model do
    subject(:command) { described_class.new(patient: patient, user: user) }

    let(:patient)                 { build_stubbed(:patient) }
    let(:user)                    { build_stubbed(:user) }
    let(:death)                   { build_stubbed(:death_modality_description) }
    let(:pd_modality_description) { build_stubbed(:pd_modality_description) }

    it { is_expected.to respond_to(:call) }

    def build_modality(description)
      Modalities::Modality.new(
        patient: patient,
        description: description,
        started_on: Time.zone.now
      )
    end

    def build_stubbed_modality(description)
      build_stubbed(
        :modality,
        patient: patient,
        description: description,
        started_on: Time.zone.now
      )
    end

    describe "#call" do
      context "when passing modality attributes rather than a modality object" do
        it "creates a new modality and makes it the patient;s current modality" do
          # No stubbed models here - want to test straight through
          patient = create(:patient)
          user = create(:user)
          svc_obj = described_class.new(
            patient: patient,
            user: user
          )

          result = svc_obj.call(
            description: create(:death_modality_description),
            started_on: Time.zone.today
          )

          expect(result).to be_a(Success)
          new_modality = result.object
          expect(new_modality).to be_a(Modalities::Modality)
          expect(patient.reload.current_modality).to eq(new_modality)
          expect(new_modality.started_on).to eq(Time.zone.today)
        end
      end

      context "when the patient does not have a current modality" do
        context "when the modality is valid" do
          it "returns a Success result object" do
            modality = build_modality(death)
            allow(modality).to receive(:save!).and_return(true)

            result = command.call(modality: modality)

            expect(modality).to have_received(:save!)
            expect(result).to be_a(Success)
            expect(result.object).to be_a(Modalities::Modality)
          end
        end

        context "when the modality is invalid" do
          it "returns a Failure result object" do
            modality = build_modality(nil)

            result = command.call(modality: modality)

            expect(result).to be_a(Failure)
            expect(result.object).to be_a(Modalities::Modality)
          end
        end
      end

      context "when the patient has a current modality" do
        context "when the modality is valid" do
          it "returns a Success result object" do
            modality = build_modality(death)
            old_modality = build_stubbed_modality(pd_modality_description)
            allow(patient).to receive(:current_modality).and_return(old_modality)
            expect(patient.current_modality).to eq(old_modality)

            expect(old_modality).to receive(:save!).and_return(true)
            expect(modality).to receive(:save!).and_return(true)

            result = command.call(modality: modality)

            expect(result).to be_a(Success)
            expect(result.object).to be_a(Modalities::Modality)
            expect(result.object.started_on).not_to be_nil
            expect(result.object.started_on).to eq(old_modality.ended_on)
          end

          it "broadcasts a patient_modality_changed event with the new modality as an argument" do
            modality = build_modality(death)
            old_modality = build_stubbed_modality(pd_modality_description)
            allow(patient).to receive(:current_modality).and_return(old_modality)
            expect(patient.current_modality).to eq(old_modality)

            listener = double("Listener")
            command.subscribe(listener)

            expect(old_modality).to receive(:save!).and_return(true)
            expect(modality).to receive(:save!).and_return(true)
            expect(listener).to receive(:patient_modality_changed_to_death).with(
              patient: patient,
              modality: modality,
              actor: user
            )

            result = command.call(modality: modality)

            expect(result).to be_a(Success)
          end
        end

        context "when the modality is invalid" do
          it "returns a Failure result object" do
            modality = build_modality(nil)

            result = command.call(modality: modality)

            expect(result).to be_a(Failure)
            expect(result.object).to be_a(Modalities::Modality)
          end

          it "does not broadcast a patient_modality_changed event" do
            modality = build_modality(nil)
            listener = double("Listener")
            command.subscribe(listener)
            expect(listener).not_to receive(:patient_modality_changed)

            command.call(modality: modality)
          end
        end
      end
    end
  end
end
