# frozen_string_literal: true

require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  describe Patient, type: :model do
    include PatientsSpecHelper
    subject(:patient) { create(:patient, nhs_number: "9999999999") }

    let(:user) { create(:user) }

    it do
      aggregate_failures do
        is_expected.to be_versioned
        is_expected.to have_db_index(:ukrdc_external_id)
        is_expected.to belong_to(:hospital_centre)
      end
    end

    it_behaves_like "Personable"
    it_behaves_like "an Accountable model"

    describe "uniqueness of patient identifiers" do
      subject(:patient) {
        build(
          :patient,
          nhs_number: "9999999999",
          local_patient_id: "1",
          local_patient_id_2: "2",
          local_patient_id_3: "3",
          local_patient_id_4: "4",
          local_patient_id_5: "5"
        )
      }

      it do
        aggregate_failures do
          is_expected.to validate_uniqueness_of(:nhs_number).case_insensitive
          is_expected.to validate_uniqueness_of(:local_patient_id).case_insensitive
        end
      end

      (2..5).each do |idx|
        it { is_expected.to validate_uniqueness_of(:"local_patient_id_#{idx}").case_insensitive }
      end
    end

    it :aggregate_failures do
      is_expected.to validate_length_of(:nhs_number).is_equal_to(10)
      is_expected.to validate_presence_of :family_name
      is_expected.to validate_presence_of :given_name
      is_expected.to validate_presence_of :born_on
      is_expected.to validate_timeliness_of(:born_on)
      is_expected.to validate_timeliness_of(:died_on)
      is_expected.to have_many(:alerts)
      is_expected.to belong_to(:country_of_birth)
      is_expected.to belong_to(:named_consultant)
      is_expected.to respond_to(:patient_at?)
    end

    describe "#nhs_number_formatted" do
      it "inserts spaces as per the NHS spec if the number is 10 digits" do
        {
          nil => nil,
          "0000000000" => "000 000 0000",
          "9999999999" => "999 999 9999",
          "999999999" => "999999999", # (only 9 digits so will not format it)
          "" => "",
          "0123456789" => "012 345 6789",
          "  " => "  ",
          "111" => "111",
          "test" => "test",
          "012 345 6789" => "012 345 6789"
        }.each do |real, formatted|
          expect(Patient.new(nhs_number: real).nhs_number_formatted).to eq(formatted)
        end
      end
    end

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

        it :aggregate_failures do
          expect(patient).to validate_presence_of(:died_on)
          expect(patient).to validate_presence_of(:first_cause_id)
        end

        context "when #skip_death_validations is true (for updating non-interactively)" do
          before { patient.skip_death_validations = true }

          it :aggregate_failures do
            expect(patient).not_to validate_presence_of(:died_on)
            expect(patient).not_to validate_presence_of(:first_cause_id)
          end
        end
      end

      context "when the current modality is not death" do
        before { allow(patient).to receive(:current_modality_death?).and_return(false) }

        it :aggregate_failures do
          expect(patient).not_to validate_presence_of(:died_on)
          expect(patient).not_to validate_presence_of(:first_cause_id)
        end
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
          "The patient must have at least one of these numbers: "\
          "HOSP1, HOSP2, HOSP3, HOSP4, HOSP5, Other Hospital Number"
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
            patient.update(died_on: "2015-02-25", by: user)
          }.to change(Patient, :count).by(0)
        end
      end
    end

    describe "#sex" do
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
        create(:modality, patient: patient, started_on: "2015-04-19", ended_on: "2015-04-20")
        create(:modality, patient: patient, started_on: "2015-04-20", ended_on: "2015-04-20")
        create(:modality, :terminated, patient: patient, started_on: "2015-04-21")

        expect(patient.current_modality.started_on).to eq(Date.parse("2015-04-20"))
      end
    end

    describe "#previous_modality" do
      it "returns last modality after the current one" do
        user = create(:user)
        hd = create(:hd_modality_description)
        death = create(:death_modality_description)
        args = { patient: patient, by: user }
        set_modality(started_on: "2015-04-19", modality_description: hd, **args)
        set_modality(started_on: "2015-04-20", modality_description: hd, **args)
        prev = set_modality(started_on: "2015-04-21", modality_description: hd, **args)
        curr = set_modality(started_on: "2015-04-21", modality_description: death, **args)

        expect(patient.current_modality.started_on).to eq(curr.started_on)
        expect(patient.previous_modality.started_on).to eq(prev.started_on)
      end
    end

    describe "#secure_id_dashed" do
      subject { described_class.new(secure_id: uuid).secure_id_dashed }

      let(:uuid) { "41a63bce-f786-47bb-aba3-c6ee6aa1e90e" }

      it { is_expected.to eq(uuid) }
    end

    describe "#to_s" do
      subject { patient.to_s(format) }

      let(:patient) {
        described_class.new(title: title, family_name: "A", given_name: "B", nhs_number: nhs_number)
      }
      let(:format) { :default }
      let(:title) { "Mrs" }
      let(:nhs_number) { "1" }

      context "when the patient has a title" do
        let(:title) { "Mrs" }

        it { is_expected.to eq("A, B (Mrs)") }
      end

      context "when the patient has no title" do
        let(:title) { "" }

        it { is_expected.to eq("A, B") }
      end

      context "when the format is :long" do
        let(:format) { :long }

        context "when there is an nhs_number" do
          let(:nhs_number) { "1" }

          it { is_expected.to eq("A, B (Mrs) (1)") }
        end

        context "when there is no nhs_number" do
          let(:nhs_number) { "" }

          it { is_expected.to eq("A, B (Mrs)") }
        end

        context "when there is no nhs_number and no title" do
          let(:nhs_number) { "" }
          let(:title) { "" }

          it { is_expected.to eq("A, B") }
        end
      end
    end

    describe "#ukrdc_external_id" do
      context "when the patient is saved without a value being explicitly set" do
        it "postgres creates a default value" do
          patient = create(:patient)

          expect(patient.reload.ukrdc_external_id.length).to be > 0
        end
      end
    end

    describe "has_paper_trail declaration" do
      it "#create creates a new version" do
        with_versioning do
          expect {
            create(:patient)
          }.to change(Patients::Version, :count).by(1)
        end
      end

      it "#update creates a new version" do
        patient = create(:patient)
        with_versioning do
          expect {
            patient.update(family_name: "X", by: patient.created_by)
          }.to change(Patients::Version, :count).by(1)
        end
      end

      it "#touch does not create a new version" do
        patient = create(:patient)
        expect {
          patient.touch
        }.to change(Patients::Version, :count).by(0)
      end

      it "#destroy" do
        patient = create(:patient)
        with_versioning do
          expect {
            patient.destroy!
          }.to change(Patients::Version, :count).by(1)
        end
      end
    end
  end
end
