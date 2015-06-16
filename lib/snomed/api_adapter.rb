module Snomed
  class ApiAdapterError < StandardError; end

  class ApiAdapter

    def initialize(config={})
      @endpoint = config[:endpoint]
      @database = config[:database]
      @version  = config[:version]
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
