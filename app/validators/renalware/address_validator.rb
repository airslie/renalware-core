# frozen_string_literal: true

module Renalware
  class AddressValidator < ActiveModel::Validator
    def validate(address)
      if address.uk? && address.postcode.blank?
        address.errors[:postcode] << "can't be blank for UK address"
      end
    end
  end
end
