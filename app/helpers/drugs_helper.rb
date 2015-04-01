module DrugsHelper
  def drugs_for(tag)
    Drug.send(tag)
  end

  def drug_select_options(selected = nil)
    options_for_select DrugType.all.map {|dt| dt.name}, selected   
  end
end
