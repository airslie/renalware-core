module Renalware
  module Letters
    class LetterQuery
      def initialize(q: nil)
        @q = q || {}
        @q[:s] ||= ["issued_on desc"]
      end

      def call
        search.result
      end

      def search
        @search ||= QueryableLetter.search(@q)
      end

      class QueryableLetter < ActiveType::Record[Letter]
        def self.finder_needs_type_condition?; false; end

        scope :state_eq, ->(state = :draft) { where(type: Letter.state_class_name(state)) }

        private_class_method :ransackable_scopes

        def self.ransackable_scopes(_auth_object = nil)
          %i(state_eq)
        end
      end
    end
  end
end
