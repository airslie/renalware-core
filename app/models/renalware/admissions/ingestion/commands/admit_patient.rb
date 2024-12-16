# frozen_string_literal: true

module Renalware
  module Admissions
    module Ingestion
      module Commands
        class AdmitPatient
          include Callable

          pattr_initialize :message
          delegate :patient_identification, :pv1, to: :message
          delegate :location, to: :pv1

          def call
            return if patient.blank?

            Admission.create!(
              hospital_ward: ward,
              patient: patient
            )
            # existing_admission = patient.appointments.where(visit_number: visit_number)

            # if existing_appointment.present?
            #   update_existing_appointment(existing_appointment)
            # else
            #   create_new_appointment(patient)
            # end
          end

          private

          def ward
            @ward ||= Hospitals::Ward.find_or_create_by(code: location.ward)
          end

          def unit
            @unit ||= Hospitals::Unit.find_by!(unit_code: "??")
          end

          def update_existing_admission(admission)
            admission.update!(
              starts_at: appointment_starts_at,
              ends_at: appointment_ends_at,
              consultant: rwconsultant,
              clinic: rwclinic
            )
          end

          def create_new_admission(patient)
            Admission.create!(
              patient: patient,
              starts_at: appointment_starts_at,
              ends_at: appointment_ends_at,
              clinic: rwclinic,
              consultant: rwconsultant,
              visit_number: visit_number
            )
          end

          def patient
            @patient ||= Feeds::PatientLocator.call(
              :adt,
              patient_identification: patient_identification
            )
          end

          # def update_patient_demographics(patient)
          #   patient = Patients::Ingestion::MessageMappers::Patient.new(message, patient).fetch
          #   patient.by = SystemUser.find
          #   patient.save!
          # end
        end
      end
    end
  end
end
