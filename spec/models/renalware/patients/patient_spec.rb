require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  describe Patient, type: :model do
    it { is_expected.to be_versioned }
    it { is_expected.to have_db_index(:ukrdc_external_id) }

    it_behaves_like "Personable"

    describe "uniqueness validation" do
      subject do
        Patient.new(local_patient_id: "1",
                    family_name: "x",
                    given_name: "x",
                    born_on: Time.zone.today,
                    nhs_number: "1234567890",
                    by: create(:user))
      end

      it { is_expected.to validate_uniqueness_of(:nhs_number).case_insensitive }
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

    subject { create(:patient, nhs_number: "1234567890") }

    describe "diabetic?" do
      it "delegates to document.diabetes.diagnosis" do
        expect(subject).not_to be_diabetic
        expect(subject.document.diabetes).to receive(:diagnosis).and_return(true)
        expect(subject).to be_diabetic
      end
    end

    describe "#valid?" do
      context "when the current modality is death" do
        before { allow(subject).to receive(:current_modality_death?).and_return(true) }

        it { expect(subject).to validate_presence_of(:died_on) }
        it { expect(subject).to validate_presence_of(:first_cause_id) }
      end

      context "when the current modality is not death" do
        before { allow(subject).to receive(:current_modality_death?).and_return(false) }

        it { expect(subject).not_to validate_presence_of(:died_on) }
        it { expect(subject).not_to validate_presence_of(:first_cause_id) }
      end

      it "validates sex" do
        subject.sex = "X"

        expect(subject).to be_invalid
      end
    end

    describe "#update" do
      let(:user) { create(:user) }

      context "when #died_on is specified" do
        subject!{ create(:patient) }

        it "stills retain patient details" do
          expect { subject.update(died_on: "2015-02-25", by: user) }
            .to change(Patient, :count).by(0)
        end
      end
    end

    describe "#sex" do
      let(:user) { create(:user) }

      it "serializes gender" do
        expect(subject.sex).to be_a Gender
      end

      it "deserializes gender" do
        subject.sex = Gender.new("F")
        subject.by = user
        subject.save! && subject.reload

        expect(subject.sex.code).to eq "F"
      end
    end

    describe "#current_modality" do
      it "returns the most recent non-deleted modality" do
        create(:modality, patient: subject, started_on: "2015-04-19")
        create(:modality, patient: subject, started_on: "2015-04-20")
        create(:modality, :terminated, patient: subject, started_on: "2015-04-21")

        expect(subject.current_modality.started_on).to eq(Date.parse("2015-04-20"))
      end
    end
  end
end
