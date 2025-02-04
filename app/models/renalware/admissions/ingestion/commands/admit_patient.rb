# frozen_string_literal: true

module Renalware
  module Admissions
    module Ingestion
      module Commands
        class AdmitPatient
          include Callable

          pattr_initialize :message
          delegate :patient_identification, :pv1, to: :message
          delegate :assigned_location,
                   :prior_location,
                   :visit_number,
                   :discharged_at,
                   :attending_doctor,
                   to: :pv1

          def call
            return if patient.blank?

            existing_admission = find_admission_with_matching_visit_number

            if existing_admission.present?
              # A02 transfer or A03 discharge or A08 update
              update(existing_admission)
            else
              create_new_admission
            end
          end

          private

          def find_admission_with_matching_visit_number
            Admission
              .currently_admitted
              .where(patient: patient)
              .where(visit_number: visit_number)
              .order(created_at: :desc)
              .first
          end

          def update(admission)
            admission.update!(
              hospital_ward: ward,
              consultant_code: attending_doctor.code,
              consultant: attending_doctor.name,
              room: assigned_location.room,
              bed: assigned_location.bed,
              building: assigned_location.building,
              floor: assigned_location.floor,
              admitted_on: pv1.admit_date&.to_date,
              discharged_on: pv1.discharge_date&.to_date,
              by: SystemUser.find
            )
          end

          def create_new_admission # rubocop:disable Metrics/MethodLength
            Admission.create!(
              patient: patient,
              admitted_on: pv1.admit_date&.to_date,
              discharged_on: pv1.discharge_date&.to_date,
              admission_type: "unknown",
              reason_for_admission: "?",
              consultant_code: attending_doctor.code,
              consultant: attending_doctor.name,
              visit_number: pv1.visit_number,
              hospital_ward: ward,
              room: assigned_location.room,
              bed: assigned_location.bed,
              building: assigned_location.building,
              floor: assigned_location.floor,
              by: SystemUser.find
            )
          end

          # If we can't find the ward, create it using the ward name as both :code and :name
          def ward
            @ward ||= Hospitals::Ward.find_or_create_by(
              code: assigned_location.ward,
              hospital_unit_id: unit.id
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
                hospital_centre: hospital_centre,
                unit_code: incoming_unit_name,
                name: incoming_unit_name,
                alias: incoming_unit_name,
                unit_type: "hospital",
                renal_registry_code: "?"
              )
            end
          end
          # rubocop:enable Metrics/MethodLength

          def hospital_centre
            @hospital_centre ||= Hospitals::Centre.where(host_site: true).first
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
