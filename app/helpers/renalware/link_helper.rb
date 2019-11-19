# frozen_string_literal: true

module Renalware
  module LinkHelper
    # A wrapper around link_to_if that will output greyed-out text to indicate the option is
    # not permitted if condition is falsey.
    def link_to_if_allowed(condition, name, options = {}, html_options = {})
      link_to_if(condition, name, options, html_options) do
        content_tag(:span, class: "no-permission") { name }
      end
    end
  end
end
