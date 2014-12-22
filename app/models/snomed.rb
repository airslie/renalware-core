class Snomed

  def self.lookup(term)
    # JSON(HTTParty.get("http://snomed.com").body)
    [{id: 12345, concept: "cool beans"}]
  end

end