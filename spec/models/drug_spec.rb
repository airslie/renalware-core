require 'rails_helper'

RSpec.describe Drug, :type => :model do

  it { should have_many(:medications) }
  it { should have_many(:patients).through(:medications) }
  it { should have_many(:drug_drug_types) }
  it { should have_many(:drug_types).through(:drug_drug_types) }

  context 'as json' do
    it 'serializes Drug compatible with select2' do
      expect(build(:drug).as_json.keys).to match_array([:id, :text])
    end
  end

  context "assign drug types to a drug" do
    before do
      @drug = build(:drug)
    end

    it "can be assigned many unique drug types" do

      @antibiotic = create(:drug_type, name: 'Antibiotic')
      @esa = create(:drug_type, name: 'ESA')

      @drug.drug_types << @antibiotic
      @drug.drug_types << @antibiotic
      @drug.drug_types << @esa

      @drug.save!
      @drug.reload

      expect(@drug.drug_types.size).to eq(2)

      expect(@drug).to be_valid
    end

  end

end
