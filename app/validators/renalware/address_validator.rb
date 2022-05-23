# frozen_string_literal: true

module Renalware
  class AddressValidator < ActiveModel::Validator
    def validate(address)
      postcode = address.postcode
      if address.uk? && postcode.blank?
        address.errors[:postcode] << "can't be blank for UK address"
      end

      if postcode.present? && !postcode.match?(/^[\w ]*$/)
        address.errors[:postcode] << "contains unexpected characters"
      end
    end
  end
end
