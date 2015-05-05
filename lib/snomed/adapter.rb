module Snomed

  class Response < OpenStruct
    def results
      self.matches
    end

    def total
      return details['total'] if details.present?
      return matches.size if matches.present?
      0
    end
  end

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

    def search(params={})
      raise "Please implement AbstractAdapter#search in a subclass"
    end
  end

  class YamlAdapter < AbstractAdapter

    cattr_accessor :data

    def search(params={})
      matches = data.select { |t| t['term'] =~ Regexp.new(params['query'], 'i') }
      Response.new({ 'details' => { 'total' => matches.size },
                     'matches' => matches })
    end

    def data
      self.class.data ||= YAML.load_file(Rails.root.join('data', 'snomed.yml'))
    end
  end

  class ApiAdapterError < StandardError; end

  class ApiAdapter < AbstractAdapter
    def initialize(config={})
      super(config)
      @endpoint = config.fetch(:endpoint, 'http://localhost:3000')
      @database = config.fetch(:database, 'en-edition')
      @version  = config.fetch(:version, 'v20150131')
    end

    def search(params={})
      response = HTTParty.get(search_url(params))
      raise Snomed::ApiAdapterError.new(response.inspect) unless response.code == 200

      parsed_body = JSON(response.body)
      Response.new(parsed_body)
    end

    def search_url(params)
      "#{@endpoint}/snomed/#{@database}/#{@version}/descriptions?#{params.to_query}"
    end
  end

  class TestAdapter < AbstractAdapter
    def search(params={})
      Response.new({ 'matches' => [{'id' => 123,'label' => 'cool beans'}] })
    end
  end
end
