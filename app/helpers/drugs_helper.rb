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
end
