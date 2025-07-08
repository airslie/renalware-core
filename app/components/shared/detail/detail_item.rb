# frozen_string_literal: true

module Shared
  class DetailItem < DescriptionListItem
    def initialize(record, field, **attrs)
      label = attr_name(record, attrs.delete(:label) || field)
      value = t_enum record.public_send(field)

      super(label, value, **attrs)
    end

    private

    def t_enum(value)
      return value unless value.is_a?(Enumerize::Value)

      value.text
    end
  end
end
