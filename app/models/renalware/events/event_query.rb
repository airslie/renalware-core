require_dependency "renalware/clinics"

module Renalware
  module Events
    class EventQuery
      attr_reader :query, :patient

      def initialize(patient:, query: {})
        @query = query
        @patient = patient
        @query[:s] = "datetime DESC" if @query[:s].blank?
      end

      def call
        search.result.for_patient(patient)
                     .includes(:event_type)
                     .eager_load(:event_type)
                     .includes(:created_by)
                     .eager_load(:created_by)
                     .page(query[:page]).per(query[:per_page])
                     .ordered
      end

      def search
        @search ||= Event.ransack(query)
      end
    end
  end
end
