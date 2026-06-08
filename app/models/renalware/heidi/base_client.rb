require "faraday"

module Renalware
  module Heidi
    class BaseClient
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
        end
      end
    end
  end
end
