module ApplicationHelper

  def gender_options
    options_for_select Patient.sexes.keys.map { |g| [I18n.t("enums.gender.#{g}"), g] }
  end

end
