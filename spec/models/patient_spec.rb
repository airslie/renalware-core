require 'rails_helper'

RSpec.describe Patient, :type => :model do

  it { should have_one :esrf_info }
  it { should have_one :patient_modality }
  it { should have_one(:modality_code).through(:patient_modality) }

  it { should accept_nested_attributes_for(:esrf_info) }
  it { should accept_nested_attributes_for(:patient_problems) }
  it { should accept_nested_attributes_for(:patient_modality) }

  it { should have_many :exit_site_infections }
  it { should have_many :peritonitis_episodes }
  it { should have_many :patient_problems }
  it { should have_many :peritonitis_episodes }
  it { should have_many :exit_site_infections }
  it { should have_many :medications }
  it { should have_many :patient_modalities }

  it { should have_many(:drugs).through(:medications).source(:medicatable) }
  it { should have_many(:exit_site_infections).through(:medications).source(:treatable) }
  it { should have_many(:peritonitis_episodes).through(:medications).source(:treatable) }
  it { should have_many(:medication_routes).through(:medications) }

  describe "updating with nested attributes containing _destroy" do
    it "should soft delete the associated record" do
      @patient = FactoryGirl.create(:patient)

      medication = FactoryGirl.create(:medication, patient: @patient)
      @patient.medications << medication

      @patient.update(medications_attributes: {
        "0" => { id: medication.id, dose: "a lot", _destroy: "1" } })

      expect(@patient.medications.with_deleted.first).to eq(medication)
      expect(@patient.medications.with_deleted.first.deleted_at).not_to be nil
    end
  end

  describe 'set_modality' do
    subject { FactoryGirl.create(:patient) }

    context 'given the patient has no modality' do
      it 'creates a patient modality on the patient' do
        subject.set_modality
        expect(subject.reload.patient_modality).not_to be_nil
        expect(subject.patient_modalities).not_to be_empty
      end
    end
    context 'given the patient has an existing modality' do
      it 'supersedes the existing modality and adds a new one on the patient' do
        modality = FactoryGirl.create(:patient_modality)
        subject.patient_modalities << modality
        subject.set_modality
        expect(subject.reload.patient_modalities.count).to eq(1)
        expect(subject.patient_modalities.with_deleted.count).to eq(2)
        expect(subject.patient_modality).not_to eq(modality)
      end
    end
  end
end
