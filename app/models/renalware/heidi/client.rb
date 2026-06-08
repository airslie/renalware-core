require "faraday"

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

      def create_session(user)
        with_jwt(user) do |token|
          response = connection.post("sessions") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
            request.headers["Heidi-Api-Key"] = api_key
            request.headers["Content-Type"] = "application/json"
            request.body = {}.to_json
          end

          result_from(response)
        end
      rescue ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      def create_session_for_patient(user, patient)
        session = create_session(user)
        return session if session.failed? || session.body["session_id"].blank?

        profile = PatientProfilesClient.new.find_or_create(user, patient)
        return profile if profile.failed?

        link_patient_profile_to_session(user, profile, session)
      end

      private

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
    end
  end
end
