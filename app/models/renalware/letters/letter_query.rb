module Renalware
  module Letters
    class LetterQuery
      def initialize(q: nil)
        @q = q || {}
      end

      def call
        search.result
      end

      def search
        @search ||= begin
          query = @q
          QueryableLetter.search(query).tap do |s|
            s.sorts = ["patient_family_name, patient_given_name"]
          end
        end
      end

      class QueryableLetter < ActiveType::Record[Letter]
        def self.finder_needs_type_condition?
          false
        end
      end
    end
  end
end
