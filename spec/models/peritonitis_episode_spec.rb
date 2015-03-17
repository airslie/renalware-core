require 'rails_helper'

RSpec.describe PeritonitisEpisode, :type => :model do
 
  it { should belong_to(:episode_type) }
  
  it { should have_many(:medications) }
  it { should have_many(:medication_routes).through(:medications) }
  it { should have_many(:patients).through(:medications) }
  it { should have_many(:infection_organisms) }
  it { should have_many(:organism_codes).through(:infection_organisms) }

  describe "peritonitis episode" do
      
    before do
      @pe = FactoryGirl.build(:peritonitis_episode)
    end
    
    context "organism codes" do

      it "can be assigned many unique organisms" do
          
        @mrsa = FactoryGirl.create(:organism_code, name: "MRSA")
        @ecoli = FactoryGirl.create(:organism_code, name: "E.Coli") 

        @pe.organism_codes << @mrsa
        @pe.organism_codes << @mrsa
        @pe.organism_codes << @ecoli

        @pe.save!
        @pe.reload

        expect(@pe.organism_codes.size).to eq(2)

        expect(@pe).to be_valid 
      end

    end
      
  end

end
