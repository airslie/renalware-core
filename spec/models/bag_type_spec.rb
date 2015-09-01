require 'rails_helper'

RSpec.describe BagType, :type => :model do

  it { should have_many :pd_regime_bags }

  it { should validate_presence_of :manufacturer }
  it { should validate_presence_of :description }
  it { should validate_presence_of :glucose_grams_per_litre }

  it { should validate_numericality_of(:glucose_grams_per_litre).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(50).allow_nil  }

  describe 'full_description' do
    it 'concatenates manufacturer and description values' do
      bag_type = build(:bag_type, manufacturer: 'Acme', description: 'Wunderdrug 2000')
      expect(bag_type.full_description).to eq('Acme Wunderdrug 2000')
    end
  end
end
