require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class DraftLetterPolicy < LetterPolicy
      def update?
        true
      end

      def submit_for_review?
        true
      end
    end
  end
end
