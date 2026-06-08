module Renalware
  module Heidi
    class SyncSession
      def initialize(session:, client: SessionsClient.new)
        @session = session
        @client = client
      end

      def call
        response = client.get(session.user, session.heidi_session_id)
        return mark_failed(response) if response.failed?

        sync_from(response.body)
      end

      private

      attr_reader :session, :client

      def sync_from(body)
        consult_note = body.dig("session", "consult_note") || {}
        note = consult_note["result"].presence

        session.update!(
          status: note.present? ? :synced : :launched,
          consult_note_status: consult_note["status"],
          consult_note: note || session.consult_note,
          raw_response: body,
          last_synced_at: Time.zone.now,
          sync_error: nil
        )

        session
      end

      def mark_failed(response)
        session.update!(
          status: :sync_failed,
          last_synced_at: Time.zone.now,
          sync_error: response.error
        )

        session
      end
    end
  end
end
