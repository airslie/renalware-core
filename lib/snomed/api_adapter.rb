module Snomed
  class ApiAdapterError < StandardError; end

  class ApiAdapter

    # TODO:
    # These would be better configured in ENV OR fall back to constants.
    API_ENDPOINT = 'http://localhost:3100'
    API_DATABASE = 'en-edition'
    API_VERSION = 'v20150131'

    def initialize(config={})
      @endpoint = config.fetch(:endpoint, API_ENDPOINT)
      @database = config.fetch(:database, API_DATABASE)
      @version  = config.fetch(:version,  API_VERSION)
    end

    def search(params={})
      response = HTTParty.get(search_url(params))
      raise Snomed::ApiAdapterError.new(response.inspect) unless response.code == 200 # TODO: Brittle.

      parsed_body = JSON(response.body)
      Response.new(parsed_body)
    end

    def search_url(params)
      "#{@endpoint}/snomed/#{@database}/#{@version}/descriptions?#{params.to_query}"
    end
  end
end
