# frozen_string_literal: true

require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Completed < Letter
      def self.policy_class
        CompletedLetterPolicy
      end
    end
  end
end
