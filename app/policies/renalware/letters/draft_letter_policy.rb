require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class DraftLetterPolicy < BasePolicy
      def mark_as_typed?
        true
      end

      def mark_as_draft?
        false
      end

      def archive?
        false
      end
    end
  end
end
