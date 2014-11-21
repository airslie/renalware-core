module ApplicationHelper

  def gender_options
    options_for_select Patient.sexes.keys.map { |g| [I18n.t("enums.gender.#{g}"), g] }
  end

  def route_options
    options_for_select PatientMedication.routes.keys.map { |r| [I18n.t("enums.route.#{r}"), r] }
  end

end
