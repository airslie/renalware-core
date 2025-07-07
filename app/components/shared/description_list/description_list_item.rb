# frozen_string_literal: true

module Shared
  class DescriptionListItem < Base
    def initialize(key, value, **attrs)
      @key = key
      @value = value
      @title = attrs.delete(:title)
      super(**attrs)
    end

    def view_template
      dt(title: @title) { @key }
      dd { @value.presence || I18n.t("unspecified") }
    end
  end
end
