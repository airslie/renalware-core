require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class InpatientQuery
      attr_reader :query

      def initialize(query = {})
        @query = query
      end

      def call
        search.result
      end

      def search
        @search ||= Inpatient.order(created_at: :desc).ransack(query)
      end
    end
  end
end
