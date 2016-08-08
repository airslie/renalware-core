require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class RequestQuery
        attr_reader :requests, :query

        def initialize(q = {})
          @q = q
          @q[:s] = "created_at DESC" unless @q[:s].present?
        end

        def call
          search.result.includes(:patient, :clinic, :consultant)
        end

        def search
          @search ||= QueryableRequest.ransack(@q)
        end

        class QueryableRequest < ActiveType::Record[Request]
          ransacker :created_on, type: :date do
            Arel.sql("DATE(created_at)")
          end
        end
      end
    end
  end
end
