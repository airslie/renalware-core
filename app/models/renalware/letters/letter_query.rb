module Renalware
  module Letters
    class LetterQuery
      def initialize(q: nil)
        @q = q || {}
        @q[:s] ||= ["patient_family_name, patient_given_name"]
      end

      def call
        search.result
      end

      def search
        @search ||= QueryableLetter.search(@q)
      end

      class QueryableLetter < ActiveType::Record[Letter]
        def self.finder_needs_type_condition?
          false
        end
      end
    end
  end
end