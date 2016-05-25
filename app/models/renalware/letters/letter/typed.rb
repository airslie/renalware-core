require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Typed < Letter
      def state
        "ready_for_review"
      end
    end
  end
end
