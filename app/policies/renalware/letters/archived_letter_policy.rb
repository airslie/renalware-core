require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class ArchivedLetterPolicy < LetterPolicy
      def update?
        false
      end

      def submit_for_review?
        false
      end

      def archive?
        false
      end
    end
  end
end
