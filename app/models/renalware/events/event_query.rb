# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Events
    class EventQuery
      attr_reader :query, :patient

      def initialize(patient:, query: {})
        @query = query
        @patient = patient
        set_default_sort_order_if_none_specified
      end

      def set_default_sort_order_if_none_specified
        @query[:s] = "date_time DESC" if @query[:s].blank?
      end

      def call
        search.result.for_patient(patient)
                     .eager_load(:patient, event_type: :category)
                     .eager_load(:created_by, :updated_by)
                     .ordered
      end

      def search
        @search ||= Event.ransack(query)
      end
    end
  end
end
