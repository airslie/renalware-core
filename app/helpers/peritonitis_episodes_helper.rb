module PeritonitisEpisodesHelper

  def medication_and_route(med)
    med.map {|m| "#{m.medicatable.name} - #{m.medication_route.name}" }.join(", ")
  end

  def organism_and_sensitivity(organism)
    organism.map {|o| "#{o.organism_code.name} - #{o.sensitivity}" }.join(", ")
  end

end
