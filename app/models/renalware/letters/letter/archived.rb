require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Archived < Letter
      def state
        "archived"
      end
    end
  end
end
