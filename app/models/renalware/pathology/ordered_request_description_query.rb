require_dependency "renalware/pathology"
require "sql/index_case_stmt"

module Renalware
  module Pathology
    class OrderedRequestDescriptionQuery
      def initialize(request_description_ids)
        @request_description_ids = request_description_ids
      end

      def call
        RequestDescription
          .where(id: @request_description_ids)
          .order(ids_index)
      end

      private

      def ids_index
        ::SQL::IndexedCaseStmt.new(:id, @request_description_ids).generate
      end
    end
  end
end
