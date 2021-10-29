# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Clinics
    module Ingestion
      class CreateOrUpdateAppointment
        pattr_initialize :message
        delegate :patient_identification, :pv1, :pv2, to: :message
        delegate :clinic, :visit_number, :consulting_doctor, to: :pv1
        delegate :expected_admit_date, to: :pv2

        def self.call(message)
          new(message).call
        end

        def call
          return unless patient && rwclinic && rwconsultant

          Appointment.create!(
            patient: Clinics.cast_patient(patient),
            starts_at: expected_admit_date,
            clinic: rwclinic,
            consultant: rwconsultant
          )
        end

        def patient
          @patient ||= Feeds::PatientLocator.call(patient_identification)
        end

        def rwclinic
          @rwclinic ||= Clinic.find_by(code: clinic.code)
        end

        def appointment
          @appointment ||= Appointment.find_by(patient: patient, visit_number: visit_number)
        end

        def rwconsultant
          @rwconsultant ||= Consultant.find_or_create_by!(code: consulting_doctor.code) do |cons|
            cons.name = consulting_doctor.name
          end
        end
      end
    end
  end
end
