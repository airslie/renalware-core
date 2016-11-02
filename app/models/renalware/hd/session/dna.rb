module Renalware
  module HD
    class Session::DNA < Session
      def self.policy_class
        DNASessionPolicy
      end

      def immutable?
        return true unless persisted?
        temporary_editing_window_has_elapsed?
      end

      private

      def temporary_editing_window_has_elapsed?
        delay = Renalware.config.delay_after_which_a_finished_session_becomes_immutable
        (Time.zone.now - delay) > created_at
      end

      # DNA sessions have a nil jsonb `document` but to avoid clumsy nil? checks
      # wherever session.documents are being used, always return a NullSessionDocument
      # which will even allow you to do eg session.document.objecta.objectb.attribute1 without
      # issue. Inspired by Avdi Grim's confident ruby approach and using his naught gem.
      def document
        super || NullSessionDocument.instance
      end
    end
  end
end
