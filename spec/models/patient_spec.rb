require 'rails_helper'

RSpec.describe Patient, :type => :model do
  it { should have_many :patient_problems } 
  it { should accept_nested_attributes_for(:patient_problems) }
  it { should have_one :patient_modality }
  it { should have_one(:modality_code).through(:patient_modality)}
  it { should accept_nested_attributes_for(:patient_modality)}
  it { should have_one :esrf_info }
  it { should accept_nested_attributes_for(:esrf_info)}
  it { should have_many :peritonitis_episodes }
  it { should have_many :exit_site_infections }

  describe "updating with nested attributes containing _destroy" do
    it "should soft delete the associated record" do
      patient = FactoryGirl.create(:patient)
      patient_medication = FactoryGirl.create(:patient_medication)
      patient.patient_medications << patient_medication
      
      patient.update(patient_medications_attributes: {
        "0" => { id: patient_medication.id, dose: "a lot", _destroy: "1" } })
      
      expect(patient.patient_medications.with_deleted.first).to eq(patient_medication)
      expect(patient.patient_medications.with_deleted.first.deleted_at).not_to be nil
    end
  end 
end
