class Snomed

  def self.lookup(term)
    # JSON(HTTParty.get("http://snomed.com").body)
    data.select { |t| t['label'] =~ Regexp.new(term, 'i') }
  end

  def self.data
    @data ||= YAML.load_file(Rails.root.join('data', 'snomed.yml'))
  end

end
