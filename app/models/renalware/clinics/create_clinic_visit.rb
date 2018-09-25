# frozen_string_literal: true

require_dependency "renalware/clinics"
require_dependency "renalware/success"
require_dependency "renalware/failure"

module Renalware
  module Clinics
    class CreateClinicVisit
      def self.call(patient, params)
        new(patient, params).call
      end

      def initialize(patient, params)
        @patient = patient
        @params = params
        @built_from_appointment_id = params.delete(:built_from_appointment_id)
      end

      def call
        ClinicVisit.transaction do
          visit = patient.clinic_visits.new(params)
          objects = OpenStruct.new(clinic_visit: visit, appointment: appointment)
          if visit.save && update_appointment_with(visit.id)
            return ::Renalware::Success.new(objects)
          else
            return ::Renalware::Failure.new(objects)
          end
        end
      end

      private

      # If the visit is being built from an appointment, e.g. a user opted to create the
      # visit from the Appointments list, we will have :built_from_appointment_id
      # in the params (its in the #new form) so we can fetch the appointment and update it to
      # indicate the visit that the appointment has transitioned to. This is currently only
      # used to provide a link to it from the Appointments list.
      def update_appointment_with(visit_id)
        return true if appointment.blank?

        appointment.becomes_visit_id = visit_id
        appointment.save
      end

      def appointment
        @appointment ||= begin
          if built_from_appointment_id.present?
            patient.appointments.find(built_from_appointment_id)
          end
        end
      end

      attr_reader :params, :patient, :built_from_appointment_id
    end
  end
end
