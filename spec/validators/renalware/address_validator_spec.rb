require 'rails_helper'

module Renalware
  describe AddressValidator, type: :validator do
    describe 'validate' do
      it 'validates that a UK address has a postcode' do
        address = Address.new(street_1: '123 North St.', country: 'United Kingdom')
        address.valid?

        expect(address.errors[:postcode]).to include("can't be blank for UK address")
      end
    end
  end
end