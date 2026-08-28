module Renalware
  module Heidi
    class LaunchClinicVisitSession
      Result = Struct.new(:success, :session, :heidi_result, :error, :link_account_url) do
        alias_method :success?, :success

        def failed? = !success?
        def account_link_required? = link_account_url.present?
      end

      def initialize(clinic_visit:, user:, client: Client.new)
        @clinic_visit = clinic_visit
        @user = user
        @client = client
      end

      def call
        link_status = client.linked_account_access(user)
        return linked_account_check_failed(link_status) if link_status.failed?
        return account_link_required unless linked?(link_status)

        heidi_result = client.create_session_for_patient(user, clinic_visit.patient)
        return failure(heidi_result) unless heidi_session_created?(heidi_result)

        session = create_session!(heidi_result)
        SyncSessionJob.perform_later(session.id)
        Result.new(true, session, heidi_result, nil, nil)
      end

      private

      attr_reader :clinic_visit, :user, :client

      def linked?(link_status)
        link_status.body["is_linked"]
      end

      def heidi_session_created?(heidi_result)
        heidi_result.success? && heidi_result.body["session_id"].present?
      end

      def create_session!(heidi_result)
        Session.create!(
          patient: clinic_visit.patient,
          clinic_visit:,
          user:,
          heidi_session_id: heidi_result.body["session_id"],
          heidi_patient_profile_id: heidi_result.body["patient_profile_id"]
        )
      end

      def account_link_required
        link_url_result = client.link_account_url_for(user)
        return failure(link_url_result, error: link_url_result.error) if link_url_result.failed?

        Result.new(
          false,
          nil,
          link_url_result,
          I18n.t("renalware.heidi.launch_clinic_visit_session.account_not_linked"),
          link_url_result.body["url"]
        )
      end

      def linked_account_check_failed(link_status)
        failure(link_status, error: linked_account_check_error(link_status))
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
