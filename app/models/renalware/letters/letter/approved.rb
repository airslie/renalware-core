require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Approved < Letter
      def self.policy_class
        ApprovedLetterPolicy
      end
    end
  end
end
