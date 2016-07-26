require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Archived < Letter
      has_one :archive, foreign_key: "letter_id"

      def self.policy_class
        ArchivedLetterPolicy
      end

      def record_archive(by: by)
        build_archive(created_by: by)
        archive.content = "<div>Archive</div>"
      end
    end
  end
end
