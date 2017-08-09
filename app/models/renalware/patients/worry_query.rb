require_dependency "renalware/patients"

module Renalware
  module Patients
    class WorryQuery
      attr_reader :query_params

      def initialize(query_params)
        @query_params = query_params
        @query_params[:s] = "date_time DESC" if @query_params[:s].blank?
      end

      def call
        search
          .result
          .includes(patient: { current_modality: [:description] })
          .order(created_at: :asc)
          .page(query_params[:page])
          .per(query_params[:per_page])
      end

      def search
        @search ||= Worry.ransack(query_params)
      end
    end
  end
end
