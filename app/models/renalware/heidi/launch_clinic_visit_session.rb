module Renalware
  module Heidi
    class LaunchClinicVisitSession
      Result = Struct.new(:success, :session, :heidi_result, :error) do
        alias_method :success?, :success

        def failed? = !success?
      end

      def initialize(clinic_visit:, user:, client: Client.new)
        @clinic_visit = clinic_visit
        @user = user
        @client = client
      end

      def call
        heidi_result = client.create_session_for_patient(user, clinic_visit.patient)
        return failure(heidi_result) unless heidi_session_created?(heidi_result)

        session = create_session!(heidi_result)
        SyncSessionJob.perform_later(session.id)
        Result.new(true, session, heidi_result, nil)
      end

      private

      attr_reader :clinic_visit, :user, :client

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

      def failure(heidi_result)
        Result.new(false, nil, heidi_result, heidi_error(heidi_result))
      end

      def heidi_error(heidi_result)
        heidi_result.error.presence || "Heidi did not return a session ID"
      end
    end
  end
end
