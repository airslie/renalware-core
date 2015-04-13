module DrugsHelper
  def drugs_for(tag)
    if tag.blank? 
      tag = "all" 
      Drug.send(tag) 
    else
      Drug.send(tag)
    end
  end

  def drug_select_options(selected = nil)
    options_for_select DrugType.all.reject{ |r| r.name == "Peritonitis" }.map { |dt| [dt.name, dt.name.downcase] }, selected    
  end

  def drug_types_colour_tag(drug_type)  
    if drug_type.map(&:name).include?("ESA")
      return "esa"
    elsif drug_type.map(&:name).include?("Immunosuppressant")
      return "immunosuppressant"
    else
      return "drug"
    end
  end

end
