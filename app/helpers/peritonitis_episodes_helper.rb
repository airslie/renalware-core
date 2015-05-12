module PeritonitisEpisodesHelper

  def medication_and_route(med_route)
    safe_join(med_route.map { |m| "<li>#{m.medicatable.name} - #{m.medication_route.name == 'Other (Please specify in notes)' ? m.medication_route.full_name : m.medication_route.name }</li>".html_safe })
  end

  def organisms_and_sensitivities(infection_organisms)
    safe_join(infection_organisms.map { |io| "<li>#{io.organism_code.name} - #{io.sensitivity}</li>".html_safe })
  end

  def organisms(infection_organisms)
    safe_join(infection_organisms.map { |io| "<li>#{io.organism_code.name}</li>".html_safe })
  end

end
