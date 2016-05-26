require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class TypedLetterPolicy < LetterPolicy
      def update?
        false
      end

      def mark_as_typed?
        false
      end
    end
  end
end
