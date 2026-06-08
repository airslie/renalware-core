require "faraday"

module Renalware
  module Heidi
    class Client
      Result = Struct.new(:success, :status, :body, :error) do
        alias_method :success?, :success

        def failed? = !success?
      end

      class ConfigurationError < StandardError; end

      def self.configured? = Renalware.config.heidi_api_key.present?

      def initialize(connection: nil, api_key: Renalware.config.heidi_api_key)
        @connection = connection
        @api_key = api_key
      end

      def jwt_for(user)
        validate_authentication_config_for(user)

        response = connection.get("jwt") do |request|
          request.headers["Heidi-Api-Key"] = api_key
          request.params["email"] = user.email
          request.params["third_party_internal_id"] = user.uuid
        end

        result_from(response)
      rescue ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      def link_account(user)
        with_jwt(user) do |token|
          response = connection.post("users/linked-account") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
            request.headers["Content-Type"] = "application/json"
            request.body = { email: user.email }.to_json
          end

          result_from(response)
        end
      rescue ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      def linked_account_access(user)
        with_jwt(user) do |token|
          response = connection.get("users/linked-account/access") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
          end

          result_from(response)
        end
      rescue ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      private

      attr_reader :api_key

      def validate_authentication_config_for(user)
        raise ConfigurationError, "HEIDI_API_KEY is not configured" if api_key.blank?

        if user.email.blank?
          raise ConfigurationError, "User email is required for Heidi authentication"
        end

        return if user.uuid.present?

        raise ConfigurationError, "User uuid is required for Heidi authentication"
      end

      def with_jwt(user)
        jwt = jwt_for(user)
        return jwt if jwt.failed?

        yield jwt.body.fetch("token")
      rescue KeyError
        failure(error: "Heidi JWT response did not include a token")
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
        end
      end
    end
  end
end
