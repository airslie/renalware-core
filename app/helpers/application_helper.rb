require 'medication_route'

module ApplicationHelper

  def gender_options
    options_for_select Patient.sexes.keys.map { |g| [I18n.t("enums.gender.#{g}"), g] }
  end

  def medication_routes(model)
    model.medication_routes.map { |r| [ r.name, r.id ] }
  end 

end
