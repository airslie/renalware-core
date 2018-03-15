# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    class PrescriptionsQuery
      def initialize(relation:, search_params: nil)
        @relation = relation
        @search_params = search_params || {}
        @search_params.reverse_merge!(s: default_search_order)
      end

      def call
        search.result
      end

      def search
        @search ||= @relation.search(@search_params)
      end

      private

      def default_search_order
        Prescription.default_search_order
      end
    end
  end
end
