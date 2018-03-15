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
        @search ||= begin
          Consult
            .includes(
              :created_by,
              :consult_site,
              :hospital_ward,
              patient: { current_modality: :description }
            )
            .active
            .order(created_at: :desc)
            .ransack(query)
        end
      end
    end
  end
end
