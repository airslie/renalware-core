require_dependency "renalware/letters"

module Renalware
  module Letters
    module QueryableLetter
      def finder_needs_type_condition?
        false
      end

      def ransackable_scopes(_auth_object = nil)
        %i(state_eq)
      end

      def state_eq(state = :draft)
        where(type: Letter.state_class_name(state))
      end
    end

    class LetterQuery
      def initialize(q: nil)
        @q = q || {}
        @q[:s] ||= ["issued_on desc"]
      end

      def call
        search.result
      end

      def search
        @search ||= Letter.extend(QueryableLetter).search(@q)
      end
    end
  end
end
