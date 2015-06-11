require 'rails_helper'

RSpec.describe BagType, :type => :model do

  it { should have_many :pd_regime_bags }

  it { should validate_presence_of :description }

  describe 'full_description' do
    it 'concatenates manufacturer and description values' do
      bag_type = build(:bag_type, manufacturer: 'Acme', description: 'Wunderdrug 2000')
      expect(bag_type.full_description).to eq('Acme Wunderdrug 2000')
    end
  end
end
