# require 'medication_route'

module Renalware
  module FormHelper
    def errors_css_class(model, attr)
      ' field_with_errors' if model.errors.key?(attr)
    end

    def gender_options
      options_for_select Patient.sexes.keys.map { |g| [I18n.t("enums.gender.#{g}"), g] }
    end

    def yes_no_radio_buttons(f, attribute)
      f.input attribute, as: :radio_buttons, item_wrapper_class: 'inline',
        collection: [["Yes", "yes"], ["No", "no"], ["Unknown", "unknown"]]
    end

    def titleize_enum(list)
      list.map { |item| [item.titleize, item] }
    end
  end
end