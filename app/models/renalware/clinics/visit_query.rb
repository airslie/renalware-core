# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class VisitQuery
      attr_reader :visits, :query

      def initialize(q = {})
        @q = q
        @q[:s] = "date DESC" if @q[:s].blank?
      end

      def call
        search.result.includes(
          :created_by,
          :updated_by,
          :clinic,
          patient: [current_modality: [:description]]
        )
      end

      def search
        @search ||= ClinicVisit.extending(RansackScopes).ransack(@q)
      end

      module RansackScopes
        def self.extended(base)
          base.ransacker :starts_at, type: :date do
            Arel.sql("DATE(starts_at)")
          end

          base.ransacker :start_time, type: :datetime do
            Arel.sql("starts_at")
          end
        end
      end
    end
  end
end
