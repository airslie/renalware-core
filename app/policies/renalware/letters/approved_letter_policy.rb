require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class ApprovedLetterPolicy < LetterPolicy
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
    end
  end
end
