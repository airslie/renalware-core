module Renalware
  module Heidi
    class SyncSessionJob < ApplicationJob
      POLL_INTERVAL = 15.seconds
      MAX_ATTEMPTS = 40

      def perform(session_id, attempts_remaining: MAX_ATTEMPTS)
        session = Session.find(session_id)
        SyncSession.new(session:).call

        reschedule_or_fail(session.reload, attempts_remaining) if session.launched?
      end

      private

      def reschedule_or_fail(session, attempts_remaining)
        if attempts_remaining <= 1
          mark_polling_exhausted(session)
        else
          reschedule(session, attempts_remaining)
        end
      end

      def reschedule(session, attempts_remaining)
        self.class
          .set(wait: POLL_INTERVAL)
          .perform_later(session.id, attempts_remaining: attempts_remaining - 1)
      end

      def mark_polling_exhausted(session)
        session.update!(
          status: :sync_failed,
          sync_error: session.sync_error.presence || "Heidi polling expired before note completion"
        )
      end
    end
  end
end
