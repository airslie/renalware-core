require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Draft < Letter
      def self.policy_class
        DraftLetterPolicy
      end

      def revise(params)
        self.attributes = params
      end

      def typed!(by:)
        becomes!(Typed).tap { |letter| letter.by = by }
      end
    end
  end
end
