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
        @search ||= QueryablePerson.search(@q)
      end

      class QueryablePerson < ActiveType::Record[Person]
        ransack_alias :name, :family_name_or_given_name
      end
    end
  end
end
