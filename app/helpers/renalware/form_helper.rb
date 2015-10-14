# require 'medication_route'

module Renalware
  module FormHelper
    def errors_css_class(model, attr)
      " field_with_errors" if model.errors.key?(attr)
    end

    def gender_options
      options_for_select Patient.sexes.keys.map { |g| [I18n.t("enums.gender.#{g}"), g] }
    end
  end
end