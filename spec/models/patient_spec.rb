require 'rails_helper'

describe Patient, :type => :model do

  it { should have_one :esrf_info }
  it { should have_one :current_modality }
  it { should have_one(:modality_code).through(:current_modality) }

  it { should accept_nested_attributes_for(:esrf_info) }
  it { should accept_nested_attributes_for(:patient_problems) }

  it { should have_many :exit_site_infections }
  it { should have_many :peritonitis_episodes }
  it { should have_many :patient_problems }
  it { should have_many :peritonitis_episodes }
  it { should have_many :exit_site_infections }
  it { should have_many :medications }
  it { should have_many :modalities }

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
    subject { create(:patient) }

    context 'given the patient has no modality' do
      it 'creates a patient modality on the patient' do
        subject.set_modality
        expect(subject.reload.current_modality).not_to be_nil
        expect(subject.modalities).not_to be_empty
      end
    end
    context 'given the patient has an existing modality' do
      before do
        @modality = create(:modality)
        subject.modalities << @modality
        subject.set_modality(start_date: Date.parse('2015-04-17'))
        subject.reload
      end
      it 'supersedes the existing modality' do
        expect(@modality.reload.termination_date).to eq(Date.parse('2015-04-16'))
        expect(subject.current_modality).not_to eq(@modality)
      end
      it 'sets a new modality for the patient' do
        expect(subject.current_modality.start_date).to eq(Date.parse('2015-04-17'))
        expect(subject.current_modality.termination_date).to be_nil
      end
    end
  end
end
