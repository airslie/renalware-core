require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class VisitQuery
      attr_reader :visits, :query

      def initialize(q = {})
        @q = q
        @q[:s] = "date DESC" unless @q[:s].present?
      end

      def call
        search.result.includes(:created_by, :clinic, patient: [current_modality: [:description]])
      end

      def search
        @search ||= QueryableVisit.ransack(@q)
      end

      class QueryableVisit < ActiveType::Record[ClinicVisit]
        ransacker :starts_at, type: :date do
          Arel.sql("DATE(starts_at)")
        end

        ransacker :start_time, type: :datetime do
          Arel.sql("starts_at")
        end
      end
    end
  end
end
