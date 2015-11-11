require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  describe Patient, :type => :model do

    it_behaves_like "Personable"

    it { should validate_presence_of :nhs_number }
    it { should validate_uniqueness_of :nhs_number }
    it { should ensure_length_of(:nhs_number).is_at_least(10) }
    it { should ensure_length_of(:nhs_number).is_at_most(10) }

    it { should validate_presence_of :family_name }
    it { should validate_presence_of :given_name }

    it { should validate_presence_of :local_patient_id }
    it { should validate_uniqueness_of :local_patient_id }

    it { should validate_presence_of :born_on }

    subject { create(:patient) }

    describe "#valid?" do
      context "given the current modality is death" do
        before { allow(subject).to receive(:current_modality_death?).and_return(true) }

        it { expect(subject).to validate_presence_of(:died_on) }
        it { expect(subject).to validate_presence_of(:first_edta_code_id) }
      end

      context "given the current modality is not death" do
        before { allow(subject).to receive(:current_modality_death?).and_return(false) }

        it { expect(subject).not_to validate_presence_of(:died_on) }
        it { expect(subject).not_to validate_presence_of(:first_edta_code_id) }
      end

      it "validates sex" do
        subject.sex = "X"

        expect(subject).to be_invalid
      end
    end

    describe "updating patient date of death" do
      subject!{ create(:patient) }

      it "should still retain patient details" do
        expect { subject.update(died_on: "2015-02-25") }.to change(Patient, :count).by(0)
      end
    end

    describe "#update" do
      describe "given _destroy is specified within nested attributes" do
        let(:medication) { FactoryGirl.create(:medication, patient: subject) }
        let(:medication_attributes) do
          {"0" => { id: medication.id, dose: "a lot", _destroy: "1" } }
        end

        it "soft deletes the associated record" do
          subject.update(medications_attributes: medication_attributes)

          expect(subject.medications.with_deleted.first).to eq(medication)
          expect(subject.medications.with_deleted.first.deleted_at).not_to be nil
        end
      end
    end

    describe "#sex" do
      it "serializes gender" do
        expect(subject.sex).to be_a Gender
      end

      it "deserializes gender" do
        subject.sex = Gender.new("F")
        subject.save! and subject.reload

        expect(subject.sex.code).to eq "F"
      end
    end

    describe "#set_modality" do
      let(:modality_description) { create(:modality_description) }

      context "given the patient has no modality" do
        it "creates a patient modality on the patient" do
          subject.set_modality(description: modality_description, started_on: Time.zone.today)

          expect(subject.reload.current_modality).not_to be_nil
          expect(subject.modalities).not_to be_empty
        end
      end

      context "given the patient has an existing modality" do
        let!(:modality) { create(:modality, patient: subject) }

        before do
          subject.set_modality(description: modality_description, started_on: Date.parse("2015-04-17"))
          subject.reload
        end

        it "supersedes the existing modality" do
          expect(modality.reload.ended_on).to eq(Date.parse("2015-04-17"))
          expect(subject.current_modality).not_to eq(modality)
        end

        it "sets a new modality for the patient" do
          expect(subject.current_modality.started_on).to eq(Date.parse("2015-04-17"))
          expect(subject.current_modality.ended_on).to be_nil
        end
      end
    end
  end
end
