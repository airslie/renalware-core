require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class ConsultQuery
      attr_reader :query

      def initialize(query = {})
        @query = query
      end

      def call
        search.result
      end

      def search
        @search ||= Consult.order(created_at: :desc).ransack(query)
      end
    end
  end
end
