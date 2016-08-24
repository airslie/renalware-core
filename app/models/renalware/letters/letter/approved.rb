require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Approved < Letter
      delegate :content, to: :archive

      def self.policy_class
        ApprovedLetterPolicy
      end
    end
  end
end
