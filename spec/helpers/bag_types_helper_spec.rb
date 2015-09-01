require 'rails_helper'

RSpec.describe BagTypesHelper, :type => :helper do

  describe 'manufacturer_options' do
    it 'should return options' do
      expect(manufacturer_options).to eq(['Baxter', 'Fresenius'])
    end
  end

end