require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Draft < Letter
      def self.policy_class
        DraftLetterPolicy
      end

      def typed!
        self.becomes!(Typed)
      end
    end
  end
end
