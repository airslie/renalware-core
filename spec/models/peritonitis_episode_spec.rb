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

  it { should accept_nested_attributes_for(:infection_organisms) }

  describe "peritonitis episode" do
      
    before do
      @pe = FactoryGirl.build(:peritonitis_episode)
    end
    
    context "organism codes" do

      it "can be assigned many unique organisms through infection_organisms" do
          
        @mrsa = FactoryGirl.create(:organism_code, name: "MRSA")
        @ecoli = FactoryGirl.create(:organism_code, name: "E.Coli") 

        @pe.organism_codes << @mrsa
        @pe.organism_codes << @mrsa
        @pe.organism_codes << @ecoli

        # @pe.infection_organisms.build(:sensitivity )

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
