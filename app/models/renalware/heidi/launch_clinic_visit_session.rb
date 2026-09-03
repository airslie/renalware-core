module Renalware
  module Heidi
    class LaunchClinicVisitSession
      Result = LaunchClinicVisitSessionResult

      def initialize(
        clinic_visit:,
        user:,
        client: Client.new,
        sessions_client: nil,
        patient_profiles_client: nil
      )
        @clinic_visit = clinic_visit
        @user = user
        @client = client
        @sessions_client = sessions_client || SessionsClient.new(client:)
        @patient_profiles_client = patient_profiles_client || PatientProfilesClient.new(client:)
      end

      def call
        link_status = client.linked_account_access(user)
        if link_status.failed?
          return failure(link_status, error: linked_account_check_error(link_status))
        end
        return account_link_required unless linked?(link_status)

        session = create_preparing_session!
        launch_result = launch_heidi_for(session)
        SyncSessionJob.perform_later(session.id) if launch_result.success?
        launch_result
      end

      private

      attr_reader :clinic_visit, :user, :client, :sessions_client, :patient_profiles_client

      def launch_heidi_for(session)
        heidi_result = create_heidi_session(session)
        return launch_failure(session, heidi_result) unless heidi_session_created?(heidi_result)

        profile = launch_patient_context(session)
        return launch_failure(session, profile) if profile.failed?

        session.update!(
          status: :launched,
          raw_response: launch_response_body(heidi_result, profile)
        )
        Result.new(true, session, heidi_result, nil, nil)
      end

      def linked?(link_status)
        link_status.body["is_linked"]
      end

      def heidi_session_created?(heidi_result)
        heidi_result.success? && heidi_result.body["session_id"].present?
      end

      def create_preparing_session!
        Session.create!(
          patient: clinic_visit.patient,
          clinic_visit:,
          user:,
          status: :preparing
        )
      end

      def create_heidi_session(session)
        sessions_client.create(user).tap do |result|
          next unless heidi_session_created?(result)

          session.update!(
            heidi_session_id: result.body["session_id"],
            raw_response: { "session" => result.body }
          )
        end
      end

      def launch_patient_context(session)
        LaunchPatientContext.new(
          session:,
          user:,
          patient: clinic_visit.patient,
          sessions_client:,
          patient_profiles_client:
        ).call
      end

      def launch_response_body(heidi_result, profile)
        heidi_result.body.merge("patient_profile" => profile.body)
      end

      def launch_failure(session, heidi_result)
        session.update!(
          status: :launch_failed,
          raw_response: heidi_result.body.presence || session.raw_response,
          sync_error: heidi_error(heidi_result)
        )
        Result.new(false, session, heidi_result, session.sync_error, nil)
      end

      def account_link_required
        link_url_result = client.link_account_url_for(user)
        return failure(link_url_result, error: link_url_result.error) if link_url_result.failed?

        error = I18n.t("renalware.heidi.launch_clinic_visit_session.account_not_linked")
        Result.new(false, nil, link_url_result, error, link_url_result.body["url"])
      end

      def failure(heidi_result, error: heidi_error(heidi_result))
        Result.new(false, nil, heidi_result, error, nil)
      end

      def heidi_error(heidi_result)
        heidi_result.error.presence || "Heidi did not return a session ID"
      end

      def linked_account_check_error(link_status)
        I18n.t(
          "renalware.heidi.launch_clinic_visit_session.link_status_failed",
          error: link_status.error
        )
      end
    end
  end
end
