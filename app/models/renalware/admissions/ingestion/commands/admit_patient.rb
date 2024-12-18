# frozen_string_literal: true

module Renalware
  module Admissions
    module Ingestion
      module Commands
        class AdmitPatient
          include Callable

          pattr_initialize :message
          delegate :patient_identification, :pv1, to: :message
          delegate :assigned_location, :prior_location, to: :pv1

          def call
            return if patient.blank?

            # Check - do we already have this admission (number)
            # Is it patient move of ward/bed

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

          # If we can't find the ward, create it using the ward name as both :code and :name
          def ward
            @ward ||= Hospitals::Ward.find_or_create_by(
              code: assigned_location.ward,
              unit_id: unit.id
            ) do |ward|
              ward.name = assigned_location.ward
            end
          end

          # If we can't find the unit by name, code or alias, then create it.
          # An example alias might be eg 'RNJ ROYALLONDON' in PV1.3.4 Facility.
          # rubocop:disable Metrics/MethodLength
          def unit
            @unit ||= begin
              incoming_unit_name = assigned_location.facility
              found_unit = Hospitals::Unit
                .where(alias: incoming_unit_name)
                .or(Hospitals::Unit.where(unit_code: incoming_unit_name))
                .or(Hospitals::Unit.where(name: incoming_unit_name))
                .first

              found_unit || Hospitals::Unit.create!(
                unit_code: incoming_unit_name,
                name: incoming_unit_name,
                alias: incoming_unit_name
              )
            end
          end
          # rubocop:enable Metrics/MethodLength

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
