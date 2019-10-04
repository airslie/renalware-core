# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class AppointmentQuery
      attr_reader :appointments, :query

      def initialize(q = {})
        @q = q
        @q[:s] = "starts_at ASC" if @q[:s].blank?
      end

      def call
        search.result.includes(
          :clinic,
          :consultant,
          patient: [current_modality: [:description]]
        )
      end

      def search
        @search ||= QueryableAppointment.ransack(@q)
      end

      class QueryableAppointment < ActiveType::Record[Appointment]
        ransacker :starts_on, type: :date do
          Arel.sql("DATE(starts_at)")
        end
      end
    end
  end
end
