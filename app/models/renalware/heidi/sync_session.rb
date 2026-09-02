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
        note = html_note(consult_note["result"])
        append_consult_note_to_clinic_visit(note) if append_consult_note?(note)

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

      def append_consult_note?(note)
        note.present? && session.consult_note.blank? && session.clinic_visit.present?
      end

      def append_consult_note_to_clinic_visit(note)
        clinic_visit = session.clinic_visit
        clinic_visit.by = session.user
        clinic_visit.update!(notes: appended_notes(clinic_visit.notes, note))
      end

      def appended_notes(existing_notes, heidi_note)
        [existing_notes.presence, "<p><strong>Heidi consult note:</strong></p>#{heidi_note}"]
          .compact
          .join
      end

      def html_note(markdown_note)
        return if markdown_note.blank?

        MarkdownToHtml.new(markdown_note).call.presence
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
