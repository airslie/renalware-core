require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Draft < Letter
      def self.policy_class
        DraftLetterPolicy
      end

      def typed!(by: by)
        self.becomes!(Typed).tap do |letter|
          letter.by = by
        end
      end
    end
  end
end
