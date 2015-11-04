require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  describe Patient, :type => :model do

    it_behaves_like "Personable"

    it { should have_one :esrf }
    it { should have_one :current_modality }
    it { should have_one(:modality_description).through(:current_modality) }

    it { should have_many :exit_site_infections }
    it { should have_many :peritonitis_episodes }
    it { should have_many :problems }
    it { should have_many :peritonitis_episodes }
    it { should have_many :exit_site_infections }
    it { should have_many :medications }
    it { should have_many :modalities }
    it { should have_many :pd_regimes }
    it { should have_many :letters }
    it { should have_many :clinic_visits }

    it { should have_many(:drugs).through(:medications).source(:medicatable) }
    it { should have_many(:exit_site_infections).through(:medications).source(:treatable) }
    it { should have_many(:peritonitis_episodes).through(:medications).source(:treatable) }
    it { should have_many(:medication_routes).through(:medications) }

    it { should accept_nested_attributes_for(:current_address) }
    it { should accept_nested_attributes_for(:address_at_diagnosis) }
    it { should accept_nested_attributes_for(:medications) }
    it { should accept_nested_attributes_for(:problems) }

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

    #Validation for date of death and cause of death
    describe "current modality death" do
      context "if current modality is death" do
        before { allow(subject).to receive(:current_modality_death?).and_return(true) }
        it { expect(subject).to validate_presence_of(:died_on) }
        it { expect(subject).to validate_presence_of(:first_edta_code_id) }
      end

      context "if current modality is not death" do
        before { allow(subject).to receive(:current_modality_death?).and_return(false) }
        it { expect(subject).not_to validate_presence_of(:died_on) }
        it { expect(subject).not_to validate_presence_of(:first_edta_code_id) }
      end
    end

    it "validates sex" do
      subject.sex = "X"
      expect(subject).to be_invalid
    end

    describe "updating patient date of death" do
      it "should still retain patient details" do
        subject
        expect { subject.update(died_on: "2015-02-25") }.to change(Patient, :count).by(0)
      end
    end

    describe "updating with nested attributes containing _destroy" do
      it "should soft delete the associated record" do

        medication = FactoryGirl.create(:medication, patient: subject)
        subject.medications << medication

        subject.update(medications_attributes: {
          "0" => { id: medication.id, dose: "a lot", _destroy: "1" } })

        expect(subject.medications.with_deleted.first).to eq(medication)
        expect(subject.medications.with_deleted.first.deleted_at).not_to be nil
      end
    end

    describe "#sex" do
      it "serializes gender" do
        expect(subject.sex).to be_a Gender
      end

      it "deserializes gender" do
        subject.sex = Gender.new("F")
        subject.save!
        subject.reload
        expect(subject.sex.code).to eq "F"
      end
    end

    describe "set_modality" do
      let(:modality_description) { create(:modality_description) }

      context "given the patient has no modality" do
        it "creates a patient modality on the patient" do
          subject.set_modality(modality_description: modality_description, started_on: Time.zone.today)
          expect(subject.reload.current_modality).not_to be_nil
          expect(subject.modalities).not_to be_empty
        end
      end

      context "given the patient has an existing modality" do
        before do
          @modality = create(:modality)
          subject.modalities << @modality
          subject.set_modality(modality_description: modality_description, started_on: Date.parse("2015-04-17"))
          subject.reload
        end

        it "supersedes the existing modality" do
          expect(@modality.reload.ended_on).to eq(Date.parse("2015-04-17"))
          expect(subject.current_modality).not_to eq(@modality)
        end

        it "sets a new modality for the patient" do
          expect(subject.current_modality.started_on).to eq(Date.parse("2015-04-17"))
          expect(subject.current_modality.ended_on).to be_nil
        end
      end

    end

  end
end
