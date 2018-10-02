# frozen_string_literal: true

require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  describe Patient, type: :model do
    subject(:patient) { create(:patient, nhs_number: "1234567890") }

    it { is_expected.to be_versioned }
    it { is_expected.to have_db_index(:ukrdc_external_id) }

    it_behaves_like "Personable"
    it_behaves_like "an Accountable model"

    describe "uniqueness of patient identifiers" do
      subject(:patient) {
        build(
          :patient,
          nhs_number: "1234567890",
          local_patient_id: "1",
          local_patient_id_2: "2",
          local_patient_id_3: "3",
          local_patient_id_4: "4",
          local_patient_id_5: "5"
        )
      }

      it { is_expected.to validate_uniqueness_of(:nhs_number).case_insensitive }
      it { is_expected.to validate_uniqueness_of(:local_patient_id).case_insensitive }
      (2..5).each do |idx|
        it { is_expected.to validate_uniqueness_of(:"local_patient_id_#{idx}").case_insensitive }
      end
    end

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

      describe "patient identification validation" do
        before do
          Renalware.configure do |config|
            config.patient_hospital_identifiers = {
              HOSP1: :local_patient_id,
              HOSP2: :local_patient_id_2,
              HOSP3: :local_patient_id_3,
              HOSP4: :local_patient_id_4,
              HOSP5: :local_patient_id_5
            }
          end
        end

        let(:error_message) {
          "The patient must have at least one of these numbers: HOSP1, HOSP2, HOSP3, HOSP4, HOSP5"
        }
        context "when the patient has no local_patient_id" do
          it "is invalid" do
            patient = Patient.new

            expect(patient).to be_invalid
            expect(patient.errors[:base]).to include(error_message)
          end
        end

        context "when the patient has just a local_patient_id" do
          it "is valid" do
            patient = Patient.new(local_patient_id: "A123")

            expect(patient.errors[:base] || []).not_to include(error_message)
          end
        end

        context "when the patient has just a local_patient_id_2" do
          it "is valid" do
            patient = Patient.new(local_patient_id_2: "A123")

            expect(patient.errors[:base] || []).not_to include(error_message)
          end
        end
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

    describe "#secure_id_dashed" do
      subject{ described_class.new(secure_id: uuid).secure_id_dashed }

      let(:uuid) { "41a63bce-f786-47bb-aba3-c6ee6aa1e90e" }

      it { is_expected.to eq(uuid) }
    end
  end
end
