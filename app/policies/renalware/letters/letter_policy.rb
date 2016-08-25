require_dependency "renalware/letters"

module Renalware
  module Letters
    class LetterPolicy < BasePolicy
      def author?; has_write_privileges? end

      def update?
        false
      end

      def submit_for_review?
        false
      end

      def reject?
        false
      end

      def approve?
        false
      end

      def complete?
        false
      end
    end
  end
end
