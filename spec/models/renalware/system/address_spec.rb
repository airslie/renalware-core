require 'rails_helper'

module Renalware
  describe Address, type: :model do
    it { should validate_presence_of :street_1 }

    describe 'to_s' do
      subject { build_stubbed(:address) }

      context 'with args' do
        it 'formats the fields passed as args' do
          expect(subject.to_s(:street_1, :postcode)).to match("#{subject.street_1}, #{subject.postcode}")
        end
      end
      context 'without args' do
        it 'returns the default string' do
          expect(subject.to_s).to eq(subject.orig_to_s)
        end
      end
    end
  end
end