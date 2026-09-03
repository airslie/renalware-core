require "faraday"
require "uri"

module Renalware
  module Heidi
    class Client < BaseClient
      Result = BaseClient::Result
      ConfigurationError = BaseClient::ConfigurationError

      def self.configured? = Renalware.config.heidi_api_key.present?

      def self.launch_url_for(session_id)
        "#{Renalware.config.heidi_scribe_session_base_url.chomp('/')}/#{session_id}"
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

      def link_account_url_for(user)
        with_jwt(user) do |token|
          Result.new(success: true, status: nil, body: { "url" => link_account_url(token) })
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

      def unlink_account(user)
        with_jwt(user) do |token|
          response = connection.delete("users/linked-account:unlink") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
            request.headers["Content-Type"] = "application/json"
          end

          result_from(response)
        end
      rescue ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      private

      def validate_authentication_config_for(user)
        raise ConfigurationError, "HEIDI_API_KEY is not configured" if api_key.blank?

        if user.email.blank?
          raise ConfigurationError, "User email is required for Heidi authentication"
        end

        return if user.uuid.present?

        raise ConfigurationError, "User uuid is required for Heidi authentication"
      end

      def link_account_url(token)
        uri = URI.parse(Renalware.config.heidi_link_account_url)
        uri.path = "/integration/widget/auth" if uri.path.blank? || uri.path == "/"
        query = URI.decode_www_form(uri.query || "").to_h
        query.merge!(
          "reset" => "true",
          "region" => Renalware.config.heidi_region,
          "t" => token,
          "productName" => "Renalware"
        )
        uri.query = URI.encode_www_form(query)
        uri.to_s
      end

      def with_jwt(user)
        jwt = jwt_for(user)
        return jwt if jwt.failed?

        yield jwt.body.fetch("token")
      rescue KeyError
        failure(error: "Heidi JWT response did not include a token")
      end
    end
  end
end
