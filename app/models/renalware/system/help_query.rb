# frozen_string_literal: true

require_dependency "renalware/system"

module Renalware
  module System
    class HelpQuery
      attr_reader :query_params

      def initialize(query_params)
        @query_params = query_params || {}
        @query_params[:s] = "name ASC" if @query_params[:s].blank?
      end

      def call
        search.result.includes(:updated_by)
      end

      def search
        @search ||= Help.ransack(query_params)
      end
    end
  end
end
