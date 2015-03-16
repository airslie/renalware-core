require 'rails_helper'

RSpec.describe Patient, :type => :model do
    
  it { should have_one :patient_modality }
  it { should have_one :esrf_info }
  it { should have_one(:modality_code).through(:patient_modality) }
  
  it { should accept_nested_attributes_for(:esrf_info) }
  it { should accept_nested_attributes_for(:patient_problems) }
  it { should accept_nested_attributes_for(:patient_modality) }

  it { should have_many :patient_problems } 
  it { should have_many :peritonitis_episodes }
  it { should have_many :exit_site_infections }
  it { should have_many :medications }

  it { should have_many(:drugs).through(:medications).source(:medicatable) }
  it { should have_many(:exit_site_infections).through(:medications).source(:treatable) }
  it { should have_many(:peritonitis_episodes).through(:medications).source(:treatable) }
  it { should have_many(:medication_routes).through(:medications) }
  
  describe "updating with nested attributes containing _destroy" do
    it "should soft delete the associated record" do
      patient = FactoryGirl.create(:patient)

      medication = FactoryGirl.create(:medication)
      patient.medications << medication
      
      patient.update(medications_attributes: {
        "0" => { id: medication.id, dose: "a lot", _destroy: "1" } })
      
      expect(patient.medications.with_deleted.first).to eq(medication)
      expect(patient.medications.with_deleted.first.deleted_at).not_to be nil
    end
  end
end
