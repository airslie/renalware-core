require 'medication_route'

module ApplicationHelper

  def gender_options
    options_for_select Patient.sexes.keys.map { |g| [I18n.t("enums.gender.#{g}"), g] }
  end

  def yes_no(bool)
    bool ? 'Yes' : 'No'
  end

  def default_for_associated(assoc, method, msg)
    assoc.present? ? assoc.send(method) : msg
  end

  def default_for_blank(val, msg)
    val.blank? ? msg : val
  end

  def medication_and_route(med_route)
    if med_route.blank?
      "No medication prescribed"
    else
      safe_join(med_route.map { |m| "<li>#{m.medicatable.name} - #{m.medication_route.name == 'Other (Please specify in notes)' ? m.medication_route.full_name : m.medication_route.name }</li>".html_safe })
    end
  end

  def organisms_and_sensitivities(infection_organisms)
    if infection_organisms.blank?
      "Unknown"
    else
      safe_join(infection_organisms.map { |io| "<li>#{io.organism_code.name} - #{io.sensitivity}</li>".html_safe })
    end
  end

  def organisms(infection_organisms)
    if infection_organisms.blank?
      "Unknown"
    else
      safe_join(infection_organisms.map { |io| "<li>#{io.organism_code.name}</li>".html_safe })
    end
  end
end
