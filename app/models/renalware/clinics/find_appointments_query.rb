require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class FindAppointmentsQuery
      attr_reader :appointments, :query

      def initialize(query_params)
        @query = Renalware::Clinics::Appointment.ransack(query_params, page, per_page)
        apply_default_sorting

        @appointments =
          @query
            .result
            .includes(:user, :patient, :clinic)
            .page(page)
            .per(per_page)
      end

      private

      def apply_default_sorting
        @query.sorts = "starts_at ASC" if @query.sorts.empty?
      end
    end
  end
end
