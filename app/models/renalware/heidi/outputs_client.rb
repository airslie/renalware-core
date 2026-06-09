module Renalware
  module Heidi
    class OutputsClient < BaseClient
      def initialize(client: Client.new, connection: nil, api_key: Renalware.config.heidi_api_key)
        super(connection:, api_key:)
        @client = client
      end

      def create_document(user, session_id, template_id:, content_type: "MARKDOWN")
        with_jwt(user) do |token|
          response = connection.post("sessions/#{session_id}/documents") do |request|
            apply_headers(request, token)
            request.body = document_payload(template_id:, content_type:).to_json
          end

          result_from(response)
        end
      rescue Client::ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      def generate_custom_template_response(user, session_id, template)
        with_jwt(user) do |token|
          response = connection.post(custom_template_path(session_id)) do |request|
            apply_headers(request, token)
            request.body = template.to_json
          end

          result_from(response)
        end
      rescue Client::ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      def clinical_codes(user, session_id)
        with_jwt(user) do |token|
          response = connection.get("sessions/#{session_id}/clinical-codes") do |request|
            apply_headers(request, token)
          end

          result_from(response)
        end
      rescue Client::ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      private

      attr_reader :client

      def document_payload(template_id:, content_type:)
        {
          document_tab_type: "DOCUMENT",
          generation_method: "TEMPLATE",
          template_id:,
          voice_style: "GOLDILOCKS",
          brain: "LEFT",
          content_type:
        }
      end

      def custom_template_path(session_id)
        "sessions/#{session_id}/client-customised-template/response"
      end

      def apply_headers(request, token)
        request.headers["Authorization"] = "Bearer #{token}"
        request.headers["Heidi-Api-Key"] = api_key
        request.headers["Content-Type"] = "application/json"
      end

      def with_jwt(user)
        jwt = client.jwt_for(user)
        return jwt if jwt.failed?

        yield jwt.body.fetch("token")
      rescue KeyError
        failure(error: "Heidi JWT response did not include a token")
      end
    end
  end
end
