module Renalware
  module Clinics
    class BuildVisitFromAppointment
      def initialize(appointment)
        @appointment = appointment
      end

      def call(opts = {})
        visit = appointment.patient.clinic_visits.build(opts)
        visit.clinic = appointment.clinic
        starts_at = appointment.starts_at
        visit.date = starts_at.to_date
        visit.time = starts_at
        visit
      end

      private

      attr_reader :appointment
    end
  end
end
