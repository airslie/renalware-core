require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class PendingReviewLetterPolicy < LetterPolicy
      def update?
        true
      end

      def submit_for_review?
        false
      end

      def reject?
        true
      end

      def approve?
        true
      end
    end
  end
end
