require 'rails_helper'

RSpec.describe PdRegimesHelper, :type => :helper do

  describe 'tidal_options' do
    it 'should produce options between 60 and 100, incrementing by 5' do
      expect(tidal_options).to eq([60, 65, 70, 75, 80, 85, 90, 95, 100])
    end
  end

end