module Renalware
  module Directory
    class PersonQuery
      def initialize(q: nil)
        @q = q || {}
        @q[:s] ||= ["family_name asc", "given_name asc"]
      end

      def call
        search.result
      end

      def search
        @search ||= Person.search(@q)
      end
    end
  end
end