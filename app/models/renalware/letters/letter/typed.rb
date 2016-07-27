require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Typed < Letter
      def self.policy_class
        TypedLetterPolicy
      end

      def archive(by:)
        becomes!(Archived).tap do |letter|
          letter.by = by
          letter.build_archive(created_by: by)
          letter.archive.content = "<div>Archive</div>"
        end
      end
    end
  end
end
