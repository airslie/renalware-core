# frozen_string_literal: true

require "faraday"

module Renalware
  module Drugs::DMD
    class OntologyClient
      ENDPOINT = "https://ontology.nhs.uk"
      CLIENT_ID = Renalware.config.nhs_client_id
      CLIENT_SECRET = Renalware.config.nhs_client_secret
      ACCESS_TOKEN_URL = "https://ontology.nhs.uk/authorisation/auth/realms/nhs-digital-terminology/protocol/openid-connect/token"

      class Unauthenticated < StandardError; end
      class RequestFailed < StandardError; end
      class NoData < StandardError; end

      def self.call
        Faraday.new(
          url: ENDPOINT,
          request: { params_encoder: Faraday::FlatParamsEncoder },
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{access_token}"
          }
        ) do |f|
          f.response :json
        end
      end

      def self.access_token
        response = Faraday.post(
          ACCESS_TOKEN_URL,
          {
            client_id: CLIENT_ID,
            client_secret: CLIENT_SECRET,
            grant_type: "client_credentials"
          }
        )

        return Unauthenticated unless response.success?

        JSON.parse(response.body)["access_token"]
      rescue JSON::ParserError, SocketError
        raise Unauthenticated
      end
    end
  end
end
