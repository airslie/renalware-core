module Renalware
  module Heidi
    class LaunchPatientContext
      def initialize(
        session:,
        user:,
        patient:,
        sessions_client:,
        patient_profiles_client:
      )
        @session = session
        @user = user
        @patient = patient
        @sessions_client = sessions_client
        @patient_profiles_client = patient_profiles_client
      end

      def call
        profile = patient_profiles_client.find_or_create(user, patient)
        return profile if profile.failed?

        profile_id = profile.body["id"]
        if profile_id.blank?
          return client_result(success: false, error: "Heidi response did not include id")
        end

        session.update!(heidi_patient_profile_id: profile_id)

        link = link_patient_profile(profile_id)
        return link if link.failed?

        context = update_session_context
        return context if context.failed?

        profile
      end

      private

      attr_reader :session, :user, :patient, :sessions_client, :patient_profiles_client

      def link_patient_profile(profile_id)
        patient_profiles_client.link_session(
          user,
          patient_profile_id: profile_id,
          session_id: session.heidi_session_id
        )
      end

      def update_session_context
        context = SessionContextBuilder.new(patient).call
        return client_result(success: true) if context.blank?

        sessions_client.update(user, session.heidi_session_id, context)
      end

      def client_result(success:, body: {}, error: nil)
        Client::Result.new(success, nil, body, error)
      end
    end
  end
end
