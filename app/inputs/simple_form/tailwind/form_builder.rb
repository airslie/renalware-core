# frozen_string_literal: true

# From https://github.com/abevoelker/simple_form_tailwind_css
require "simple_form"
require "simple_form/inputs"
require "simple_form/form_builder"
require "simple_form/tailwind/inputs/append_string_input"
require "simple_form/tailwind/inputs/password_input"
require "simple_form/tailwind/inputs/prepend_string_input"
require "simple_form/tailwind/inputs/string_input"

module SimpleForm
  module Tailwind
    class FormBuilder < SimpleForm::FormBuilder
      map_type :string, :email, :search, :tel, :url, :uuid, :citext, to: SimpleForm::Tailwind::Inputs::StringInput
      map_type :password,                                            to: SimpleForm::Tailwind::Inputs::PasswordInput
      map_type :prepend_string,                                      to: SimpleForm::Tailwind::Inputs::PrependStringInput
      map_type :append_string,                                       to: SimpleForm::Tailwind::Inputs::AppendStringInput

      def error_notification(options = {})
        SimpleForm::Tailwind::ErrorNotification.new(self, options).render
      end
    end
  end
end
