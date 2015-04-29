module Snomed
  class AdapterFactory
    attr_accessor :adapter

    def initialize(config={})
      @adapter = config.fetch(:adapter, YamlAdapter).new
    end
  end

  class AbstractAdapter
    def initialize(opts={})
      @opts = opts
    end

    def search(term, params={})
      raise "Please implement AbstractAdapter#search in a subclass"
    end
  end

  class YamlAdapter < AbstractAdapter

    cattr_accessor :data

    def search(term, params={})
      { 'matches' => data.select { |t| t['label'] =~ Regexp.new(term, 'i') } }
    end

    def data
      self.class.data ||= YAML.load_file(Rails.root.join('data', 'snomed.yml'))
    end
  end

  class ApiAdapter < AbstractAdapter
    def initialize(config={})
      super(config)
      @endpoint = config.fetch(:endpoint, 'http://localhost:3000')
      @database = config.fetch(:database, 'en-edition')
      @version  = config.fetch(:version, 'v20150131')
    end

    def search(term, params={})
      response = HTTParty.get("#{@endpoint}/snomed/#{@database}/#{@version}/descriptions?query=#{term}").body
      JSON(response)
    end
  end

  class TestAdapter < AbstractAdapter
    def search(term, params={})
      { 'matches' => [{'id' => 123,'label' => 'cool beans'}] }
    end
  end
end
