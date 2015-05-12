require 'medication_route'

module ApplicationHelper

  def gender_options
    options_for_select Patient.sexes.keys.map { |g| [I18n.t("enums.gender.#{g}"), g] }
  end

  def yes_no(bool)
    bool ? 'Yes' : 'No'
  end

end
