module Renalware
  module Heidi
    class SyncSessionJob < ApplicationJob
      POLL_INTERVAL = 30.seconds
      MAX_ATTEMPTS = 30

      def perform(session_id, attempts_remaining: MAX_ATTEMPTS)
        session = Session.find(session_id)
        SyncSession.new(session:).call

        reschedule(session, attempts_remaining) if session.reload.launched?
      end

      private

      def reschedule(session, attempts_remaining)
        return if attempts_remaining <= 1

        self.class
          .set(wait: POLL_INTERVAL)
          .perform_later(session.id, attempts_remaining: attempts_remaining - 1)
      end
    end
  end
end
