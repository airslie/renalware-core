require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class TypedLetterPolicy < LetterPolicy
      def mark_as_typed?
        false
      end

      def mark_as_draft?
        true
      end

      def archive?
        true
      end
    end
  end
end
