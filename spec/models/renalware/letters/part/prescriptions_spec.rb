require "rails_helper"

module Renalware::Letters
  describe Part::Prescriptions do
    subject(:part) { Part::Prescriptions.new(patient) }

    let(:user) { create(:user) }
    let(:patient) { create(:patient) }
    let(:default_drug) { create(:drug, name: "::drug name::") }

    def terminated_prescription(terminated_on:, drug: default_drug)
      create(:prescription,
             patient: patient,
             drug: drug,
             prescribed_on: "2009-01-01",
             termination: build(:prescription_termination, terminated_on: terminated_on),
             by: user)
    end

    def current_prescription(prescribed_on: "2009-01-01", drug: default_drug)
      create(:prescription,
             patient: patient,
             drug: drug,
             prescribed_on: prescribed_on,
             updated_at: prescribed_on,
             created_at: prescribed_on,
             by: user)
    end

    describe "self" do
      it "returns an OpenStruct of different sets of prescriptions" do
        expect(part).to respond_to(:current)
        expect(part).to respond_to(:recently_changed)
        expect(part).to respond_to(:recently_stopped)
      end
    end

    describe "#current" do
      it "comprises only current prescriptions" do
        patient.prescriptions << terminated_prescription(terminated_on: Time.zone.today - 1.day)
        patient.prescriptions << current = current_prescription

        expect(part.current.to_a).to eq([current])
      end
    end

    describe "#recently_changed" do
      it "comprises only prescriptions changed in the last 14 days" do
        patient.prescriptions << terminated_prescription(terminated_on: 1.day.ago)
        patient.prescriptions << current_prescription(prescribed_on: 15.days.ago)
        patient.prescriptions << recently_changed = current_prescription(prescribed_on: 13.days.ago)

        expect(part.recently_changed.to_a).to eq([recently_changed])
      end
    end

    describe "#recently_stopped" do
      it "comprises prescriptions stopped within the last 14 days having a drug which is not in " \
         "the #current list" do

        other_drug = create(:drug, name: "a drug not in the current list")

        # No as not terminated
        patient.prescriptions << current_prescription
        # No we already have drug in current list
        patient.prescriptions << terminated_prescription(terminated_on: 13.days.ago)
        # No as not within 14 days
        patient.prescriptions << terminated_prescription(terminated_on: 15.days.ago)
        # YES as terminated and drug not in current list
        recently_stopped_prescription = terminated_prescription(terminated_on: 13.days.ago,
                                                                drug: other_drug)
        patient.prescriptions << recently_stopped_prescription

        expect(part.recently_stopped.to_a).to eq([recently_stopped_prescription])
      end
    end
  end
end
