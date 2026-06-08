module Renalware
  module Heidi
    class SessionsClient < BaseClient
      def initialize(client: Client.new, connection: nil, api_key: Renalware.config.heidi_api_key)
        super(connection:, api_key:)
        @client = client
      end

      def create(user)
        with_jwt(user) do |token|
          response = connection.post("sessions") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
            request.headers["Heidi-Api-Key"] = api_key
            request.headers["Content-Type"] = "application/json"
            request.body = {}.to_json
          end

          result_from(response)
        end
      rescue Client::ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      def create_for_patient(user, patient)
        session = create(user)
        return session if session.failed? || session.body["session_id"].blank?

        profile = PatientProfilesClient.new.find_or_create(user, patient)
        return profile if profile.failed?

        link_and_update_context(user, patient, profile, session)
      end

      def update(user, session_id, payload)
        with_jwt(user) do |token|
          response = connection.patch("sessions/#{session_id}") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
            request.headers["Heidi-Api-Key"] = api_key
            request.headers["Content-Type"] = "application/json"
            request.body = payload.to_json
          end

          result_from(response)
        end
      rescue Client::ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      def get(user, session_id)
        with_jwt(user) do |token|
          response = connection.get("sessions/#{session_id}") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
            request.headers["Heidi-Api-Key"] = api_key
          end

          result_from(response)
        end
      rescue Client::ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      private

      attr_reader :client

      def link_and_update_context(user, patient, profile, session)
        link = link_patient_profile_to_session(user, profile, session)
        return link if link.failed?

        context = update_session_context(user, session.body["session_id"], patient)
        return context if context.failed?

        session
      end

      def link_patient_profile_to_session(user, profile, session)
        link = PatientProfilesClient.new.link_session(
          user,
          patient_profile_id: profile.body.fetch("id"),
          session_id: session.body["session_id"]
        )
        return link if link.failed?

        session.body["patient_profile_id"] = profile.body["id"]
        session.body["patient_profile_session_link"] = link.body
        session
      rescue KeyError => e
        failure(error: "Heidi response did not include #{e.key}")
      end

      def update_session_context(user, session_id, patient)
        context = SessionContextBuilder.new(patient).call
        return Result.new(success: true, status: nil, body: {}) if context.blank?

        update(user, session_id, context)
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
