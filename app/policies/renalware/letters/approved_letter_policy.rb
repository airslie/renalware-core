require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class ApprovedLetterPolicy < LetterPolicy
      def complete?
        true
      end
    end
  end
end
