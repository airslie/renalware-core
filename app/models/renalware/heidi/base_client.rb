require "faraday"

module Renalware
  module Heidi
    class BaseClient
      OPEN_TIMEOUT = 5
      READ_TIMEOUT = 20
      WRITE_TIMEOUT = 10

      Result = Struct.new(:success, :status, :body, :error) do
        alias_method :success?, :success

        def failed? = !success?
      end

      class ConfigurationError < StandardError; end

      def initialize(connection: nil, api_key: Renalware.config.heidi_api_key)
        @connection = connection
        @api_key = api_key
      end

      private

      attr_reader :api_key

      # The object whose #jwt_for(user) fetches the JWT used to authenticate requests.
      # Client provides its own; SessionsClient and PatientProfilesClient delegate to
      # the Client instance they were given.
      def jwt_source
        self
      end

      def with_jwt(user)
        jwt = jwt_source.jwt_for(user)
        return jwt if jwt.failed?

        yield jwt.body.fetch("token")
      rescue KeyError
        failure(error: "Heidi JWT response did not include a token")
      rescue ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      def result_from(response)
        Result.new(
          success: response.success?,
          status: response.status,
          body: response.body.presence || {},
          error: response.success? ? nil : response_error(response)
        )
      end

      def response_error(response)
        response.body.presence || response.reason_phrase.presence || "Heidi API request failed"
      end

      def failure(error:, status: nil, body: {})
        Result.new(success: false, status:, body:, error:)
      end

      def connection
        @connection ||= Faraday.new(
          url: Renalware.config.heidi_api_base_url,
          headers: { "Accept" => "application/json" }
        ) do |faraday|
          faraday.request :json
          faraday.response :json
          faraday.options.open_timeout = OPEN_TIMEOUT
          faraday.options.read_timeout = READ_TIMEOUT
          faraday.options.write_timeout = WRITE_TIMEOUT
        end
      end
    end
  end
end
