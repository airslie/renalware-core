module PeritonitisEpisodesHelper

  def medication_and_route(med)
    safe_join(med.map { |m| "<li>#{m.medicatable.name} - #{m.medication_route.name == 'Other (Please specify in notes)' ? m.medication_route.full_name : m.medication_route.name }</li>".html_safe })
  end

  def organism_and_sensitivity(organism)
    safe_join(organism.map { |o| "<li>#{o.organism_code.name}</li>".html_safe })
  end

end
