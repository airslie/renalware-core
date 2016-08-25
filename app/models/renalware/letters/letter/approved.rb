require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Approved < Letter
      def self.policy_class
        ApprovedLetterPolicy
      end

      def complete(by:)
        becomes!(Completed).tap do |letter|
          letter.by = by
        end
      end
    end
  end
end
