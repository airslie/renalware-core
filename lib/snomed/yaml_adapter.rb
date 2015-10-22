require 'snomed/response'

module Snomed
  class YamlAdapter

    cattr_accessor :data

    def initialize(opts={})
      @yml_path = opts.fetch(:yaml_path, Rails.root.join("db", "static", "snomed.yml"))
    end

    def search(params={})
      params.stringify_keys!
      matches = data.select { |t| t['term'] =~ Regexp.new(params['query'], 'i') }
      Response.new({ 'details' => { 'total' => matches.size },
                     'matches' => matches })
    end

    def data
      self.class.data ||= YAML.load_file(@yml_path)
    end
  end
end
