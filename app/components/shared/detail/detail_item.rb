# frozen_string_literal: true

module Shared
  class DetailItem < DescriptionListItem
    def initialize(record, field, **attrs)
      label = attrs.delete(:label) || field
      value = record.public_send(field)
      dig = attrs.delete(:dig)
      value = value.public_send(dig) if dig

      super(label, value, **attrs)
    end
  end
end
