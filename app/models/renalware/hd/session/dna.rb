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
    end
  end
end
