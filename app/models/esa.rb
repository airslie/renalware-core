class Esa < Drug
 
  index_name "drugs"

  document_type "drug"
  
  def display_type
    "ESA"
  end

  def as_indexed_json(options={})
    as_json(only: %i(name type))
  end
end
