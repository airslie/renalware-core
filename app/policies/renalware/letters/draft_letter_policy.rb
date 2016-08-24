require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class DraftLetterPolicy < BasePolicy
      def submit_for_review?
        true
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
