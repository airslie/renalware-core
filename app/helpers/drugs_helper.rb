module DrugsHelper
  def drugs_for(type)
    Drug.where(:type =>  type)
  end

  def drug_select_options(selected = nil)
    options_for_select [["Standard Drug", "Drug"], ["ESA", "Esa"], ["Immunosuppressant", "Immunosuppressant"]], selected
  end
end
