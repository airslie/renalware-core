require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Typed < Letter
      def self.policy_class
        TypedLetterPolicy
      end

      def archive!(by:)
        becomes!(Archived).tap do |letter|
          letter.by = by
          letter.archived_copy = "<div>Archive</div>"
        end
      end
    end
  end
end
