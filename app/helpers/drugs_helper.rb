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
    options_for_select DrugType.all.map { |dt| [dt.name, dt.name.downcase] }, selected   
    # options_for_select DrugType.all, selected   
  end
end
