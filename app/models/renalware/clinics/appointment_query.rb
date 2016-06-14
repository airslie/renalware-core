require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class AppointmentQuery
      attr_reader :appointments, :query

      def initialize(q = {})
        @q = q
        @q[:s] = "starts_at ASC" unless @q[:s].present?
      end

      def call
        search.result.includes(:user, :patient, :clinic)
      end

      def search
        @search ||= QueryableAppointment.ransack(@q)
      end

      private


      class QueryableAppointment < ActiveType::Record[Appointment]
        ransacker :starts_at, type: :date do
          Arel.sql("DATE(starts_at)")
        end
      end
    end
  end
end
