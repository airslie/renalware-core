require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Archived < Letter
      has_one :archive, foreign_key: "letter_id"

      delegate :content, to: :archive

      def self.policy_class
        ArchivedLetterPolicy
      end

      def archived_by
        archive.created_by
      end
    end
  end
end
