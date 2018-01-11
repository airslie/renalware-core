require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  describe Patient, type: :model do
    subject(:patient) { create(:patient, nhs_number: "1234567890") }

    it { is_expected.to be_versioned }
    it { is_expected.to have_db_index(:ukrdc_external_id) }

    it_behaves_like "Personable"

    it { is_expected.to validate_uniqueness_of(:nhs_number).case_insensitive }
    it { is_expected.to validate_length_of(:nhs_number).is_at_least(10) }
    it { is_expected.to validate_length_of(:nhs_number).is_at_most(10) }

    it { is_expected.to validate_presence_of :family_name }
    it { is_expected.to validate_presence_of :given_name }

    it { is_expected.to validate_presence_of :born_on }

    it { is_expected.to validate_timeliness_of(:born_on) }
    it { is_expected.to validate_timeliness_of(:died_on) }

    it { is_expected.to have_many(:alerts) }
    it { is_expected.to belong_to(:country_of_birth) }

    it { is_expected.to respond_to(:patient_at?) }

    describe "diabetic? delegates to document.diabetes.diagnosis" do
      context "when the patient is diabetic" do
        before { allow(patient.document.diabetes).to receive(:diagnosis).and_return(true) }

        it { is_expected.to be_diabetic }
      end

      context "when the patient is not diabetic" do
        before { allow(patient.document.diabetes).to receive(:diagnosis).and_return(false) }

        it { is_expected.not_to be_diabetic }
      end
    end

    describe "#valid?" do
      context "when the current modality is death" do
        before { allow(patient).to receive(:current_modality_death?).and_return(true) }

        it { expect(patient).to validate_presence_of(:died_on) }
        it { expect(patient).to validate_presence_of(:first_cause_id) }
      end

      context "when the current modality is not death" do
        before { allow(patient).to receive(:current_modality_death?).and_return(false) }

        it { expect(patient).not_to validate_presence_of(:died_on) }
        it { expect(patient).not_to validate_presence_of(:first_cause_id) }
      end

      it "validates sex" do
        patient.sex = "X"

        expect(patient).to be_invalid
      end
    end

    describe "#update" do
      context "when #died_on is specified" do
        it "stills retain patient details" do
          patient = create(:patient)
          expect {
            patient.update(died_on: "2015-02-25", by: create(:user))
          }.to change(Patient, :count).by(0)
        end
      end
    end

    describe "#sex" do
      let(:user) { create(:user) }

      it "serializes gender" do
        expect(patient.sex).to be_a Gender
      end

      it "deserializes gender" do
        patient.sex = Gender.new("F")
        patient.by = user
        patient.save! && patient.reload

        expect(patient.sex.code).to eq "F"
      end
    end

    describe "#current_modality" do
      it "returns the most recent non-deleted modality" do
        create(:modality, patient: patient, started_on: "2015-04-19")
        create(:modality, patient: patient, started_on: "2015-04-20")
        create(:modality, :terminated, patient: patient, started_on: "2015-04-21")

        expect(patient.current_modality.started_on).to eq(Date.parse("2015-04-20"))
      end
    end
  end
end
