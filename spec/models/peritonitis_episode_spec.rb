require 'rails_helper'

RSpec.describe PeritonitisEpisode, :type => :model do
 
  it { should belong_to(:patient) }
  it { should belong_to(:episode_type) }
  it { should belong_to(:fluid_description) }
  
  it { should have_many(:medications) }
  it { should have_many(:medication_routes).through(:medications) }
  it { should have_many(:patients).through(:medications) }
  it { should have_many(:infection_organisms) }
  it { should have_many(:organism_codes).through(:infection_organisms) }

  it { should accept_nested_attributes_for(:medications) }
  it { should accept_nested_attributes_for(:infection_organisms) }

  describe "peritonitis episode" do
      
    before do
      @pe = FactoryGirl.build(:peritonitis_episode)
      @drug_1 = FactoryGirl.create(:drug, name: "Amoxicillin")
      @drug_2 = FactoryGirl.create(:drug, name: "Penicillin")
      @drug_type_1 = FactoryGirl.create(:drug_type, name: "Antibiotic")
      @drug_type_2 = FactoryGirl.create(:drug_type, name: "Peritonitis")
      @drug_drug_type_1 = FactoryGirl.create(:drug_drug_type, drug_id: @drug_1.id, drug_type_id: @drug_type_1.id)
      @drug_drug_type_2 = FactoryGirl.create(:drug_drug_type, drug_id: @drug_1.id, drug_type_id: @drug_type_2.id)
      @drug_drug_type_3 = FactoryGirl.create(:drug_drug_type, drug_id: @drug_2.id, drug_type_id: @drug_type_1.id)
      @drug_drug_type_4 = FactoryGirl.create(:drug_drug_type, drug_id: @drug_2.id, drug_type_id: @drug_type_2.id)
    end

    context "medications" do  
      it "can be assigned many medications" do
        
        @medication_one = FactoryGirl.create(:medication,
          patient_id: @patient,
          medicatable_id: @drug_1,
          medicatable_type: "Drug",
          treatable_id: 1,
          treatable_type: "PeritonitisEpisode",
          dose: "20mg",
          medication_route_id: 1,
          frequency: "daily",
          notes: "with food",
          date: "02/03/2015",
          deleted_at: "NULL",
          created_at: "2015-02-03 18:21:04",
          updated_at: "2015-02-05 18:21:04"
        )
        
        @medication_two = FactoryGirl.create(:medication,
          patient_id: @patient,
          medicatable_id: @drug_2,
          medicatable_type: "Drug",
          treatable_id: 1,
          treatable_type: "PeritonitisEpisode",
          dose: "20mg",
          medication_route_id: 1,
          frequency: "daily",
          notes: "with food",
          date: "02/03/2015",
          deleted_at: "NULL",
          created_at: "2015-02-03 18:21:04",
          updated_at: "2015-02-05 18:21:04"
        )

        @pe.medications << @medication_one
        @pe.medications << @medication_two
        
      end
    end
    
    context "organism codes" do
      it "can be assigned many unique organisms through infection_organisms" do
          
        @mrsa = FactoryGirl.create(:organism_code, name: "MRSA")
        @ecoli = FactoryGirl.create(:organism_code, name: "E.Coli") 

        @pe.organism_codes << @mrsa
        @pe.organism_codes << @mrsa
        @pe.organism_codes << @ecoli

        @pe.save!
        @pe.reload

        expect(@pe.organism_codes.size).to eq(2)
        expect(@pe.organism_codes.map(&:name)).to eq(["MRSA", "E.Coli"])
        expect(@pe.organism_codes[0].name).to eq("MRSA")
        expect(@pe.organism_codes[1].name).to eq("E.Coli")

        expect(@pe).to be_valid 
      end

      it "should record a sensitivity per organism" do

        @pe.infection_organisms.build(sensitivity: "Sensitive to MRSA.")
        @pe.infection_organisms.build(sensitivity: "Sensitive to E.Coli.")

        @pe.save!
        @pe.reload

        expect(@pe.infection_organisms.size).to eq(2)
        expect(@pe.infection_organisms.map(&:sensitivity)).to eq(["Sensitive to MRSA.", "Sensitive to E.Coli."])
        expect(@pe.infection_organisms[0].sensitivity).to eq("Sensitive to MRSA.")
        expect(@pe.infection_organisms[1].sensitivity).to eq("Sensitive to E.Coli.")

        expect(@pe).to be_valid
      end
    end

  end

end
