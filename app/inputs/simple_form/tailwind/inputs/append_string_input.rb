# frozen_string_literal: true

# From https://github.com/abevoelker/simple_form_tailwind_css
require "simple_form"
require "simple_form/inputs"
require "simple_form/inputs/string_input"
require "simple_form/tailwind/overwrite_class_with_error_or_valid_class"

module SimpleForm
  module Tailwind
    module Inputs
      class AppendStringInput < SimpleForm::Inputs::StringInput
        include SimpleForm::Tailwind::OverwriteClassWithErrorOrValidClass

        def input(*args, &blk)
          input_html_options[:type] ||= "text"

          super
        end

        def append(wrapper_options = nil)
          template.content_tag(:span, options[:append], class: "inline-flex items-center px-3 rounded-r-md border border-l-0 border-gray-300 bg-gray-50 text-gray-500 sm:text-sm")
        end
      end
    end
  end
end
