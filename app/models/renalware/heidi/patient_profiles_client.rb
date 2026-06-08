require "faraday"

module Renalware
  module Heidi
    class PatientProfilesClient < BaseClient
      def initialize(
        client: Client.new,
        connection: nil,
        api_key: Renalware.config.heidi_api_key
      )
        super(connection:, api_key:)
        @client = client
      end

      def find_or_create(user, patient)
        profiles = find(user, ehr_patient_id: ehr_patient_id_for(patient))
        return profiles if profiles.failed?

        profile = profiles.body.fetch("data", []).first
        return result(success: true, status: profiles.status, body: profile) if profile.present?

        created = create(user, patient)
        return created if created.failed?

        result(success: true, status: created.status, body: created.body.fetch("data"))
      rescue KeyError => e
        failure(error: "Heidi response did not include #{e.key}")
      end

      def find(user, ehr_patient_id:)
        with_jwt(user) do |token|
          response = connection.get("patient-profiles") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
            request.headers["Heidi-Api-Key"] = api_key
            request.params["ehr_patient_id"] = ehr_patient_id
          end

          result_from(response)
        end
      rescue Client::ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      def create(user, patient)
        with_jwt(user) do |token|
          response = connection.post("patient-profiles") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
            request.headers["Heidi-Api-Key"] = api_key
            request.headers["Content-Type"] = "application/json"
            request.body = patient_profile_payload(patient).to_json
          end

          result_from(response)
        end
      rescue Client::ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      def link_session(user, patient_profile_id:, session_id:)
        with_jwt(user) do |token|
          response = connection.post("patient-profiles/#{patient_profile_id}/sessions") do |request|
            request.headers["Authorization"] = "Bearer #{token}"
            request.headers["Heidi-Api-Key"] = api_key
            request.headers["Content-Type"] = "application/json"
            request.body = { session_ids: [session_id] }.to_json
          end

          result_from(response)
        end
      rescue Client::ConfigurationError, Faraday::Error, JSON::ParserError => e
        failure(error: e.message)
      end

      private

      attr_reader :client

      def with_jwt(user)
        jwt = client.jwt_for(user)
        return jwt if jwt.failed?

        yield jwt.body.fetch("token")
      rescue KeyError
        failure(error: "Heidi JWT response did not include a token")
      end

      def patient_profile_payload(patient)
        {
          first_name: patient.given_name,
          last_name: patient.family_name,
          birth_date: patient.born_on&.iso8601,
          gender: heidi_gender(patient),
          ehr_patient_id: ehr_patient_id_for(patient),
          demographic_string: patient_demographic_string(patient)
        }.compact_blank
      end

      def patient_demographic_string(patient)
        [patient.full_name, patient.sex&.to_s, patient.born_on&.iso8601].compact_blank.join(", ")
      end

      def ehr_patient_id_for(patient)
        patient.secure_id_dashed || patient.secure_id
      end

      def heidi_gender(patient)
        case patient.sex&.to_s
        when "M" then "male"
        when "F" then "female"
        when "NK" then "unknown"
        else "other"
        end
      end

      def result(success:, status:, body:, error: nil)
        Result.new(success:, status:, body:, error:)
      end
    end
  end
end
