# frozen_string_literal: true

module Renalware
  module Clinics
    module Ingestion
      module Commands
        class CreateOrUpdateAppointment
          include Callable

          pattr_initialize :message
          delegate :patient_identification, :pv1, :pv2, :sch, to: :message
          delegate :clinic, :visit_number, :consulting_doctor, :attending_doctor, to: :pv1

          # If we match incoming clinic code then we create an appointment. This might mean
          # creating the patient and consultant JIT if they do not yet exist in Renalware.
          def call
            return if rwclinic.blank?

            patient = find_or_create_patient

            Appointment.create!(
              patient: Clinics.cast_patient(patient),
              starts_at: appointment_starts_at,
              ends_at: appointment_ends_at,
              clinic: rwclinic,
              consultant: rwconsultant,
              visit_number: visit_number
            )
          end

          private

          def appointment_starts_at
            message.siu? ? sch.starts_at : pv2.expected_admit_date
          end

          def appointment_ends_at
            message.siu? ? sch.ends_at : nil
          end

          def find_or_create_patient
            # This is the standard A28/31 add/update command which will find or add the patient
            # using the contents of the PID segment
            reason = "Clinic appt"
            Patients::Ingestion::Commands::AddPatient.call(message, reason).tap do |patient|
              assign_the_clinic_default_modality_to_new_patients(patient)
              update_patient_demographics(patient)
            end
          end

          def update_patient_demographics(patient)
            patient = Patients::Ingestion::MessageMappers::Patient.new(message, patient).fetch
            patient.by = SystemUser.find
            patient.save!
          end

          # If the clinic has a default modality description against it, assign that to the patient
          # if they have no modality yet.
          def assign_the_clinic_default_modality_to_new_patients(patient)
            return if patient.current_modality.present? ||
                      rwclinic.default_modality_description.blank?

            result = Modalities::ChangePatientModality.new(
              patient: patient,
              user: Renalware::SystemUser.find
            ).call(
              description_id: rwclinic.default_modality_description.id,
              started_on: Time.zone.now
            )
            raise(ActiveModel::ValidationError, result.object) if result.failure?
          end

          def rwclinic
            @rwclinic ||= Clinic.find_by(code: clinic.code)
          end

          def rwconsultant
            @rwconsultant ||= Consultant.find_or_create_by!(code: consultant.code) do |cons|
              cons.name = consultant.name
            end
          end

          # MSE use PV1.9 consulting_doctor
          # BLT use PV1.7 attending_doctor and consulting_doctor is blank
          def consultant
            consulting_doctor.code.present? ? consulting_doctor : attending_doctor
          end
        end
      end
    end
  end
end
