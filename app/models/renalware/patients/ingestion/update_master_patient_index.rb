# frozen_string_literal: true

require "renalware/feeds"
require "attr_extras"

module Renalware
  module Patients
    module Ingestion
      class UpdateMasterPatientIndex
        pattr_initialize :hl7_message, :by
        attr_reader :rw_patient
        delegate :patient_identification, to: :hl7_message

        def self.call(hl7_message, by)
          new(hl7_message, by).call
        end

        def call
          return unless hl7_message.adt?

          @rw_patient = find_patient_in_renalware
          update_or_create_abridged_patient
          update_primary_care_physician
          update_practice
        end

        private

        # rubocop:disable Metrics/AbcSize
        def update_or_create_abridged_patient
          find_or_initialize_abridged_patient.update!(
            given_name: patient_identification.given_name,
            family_name: patient_identification.family_name,
            sex: patient_identification.sex,
            title: patient_identification.title,
            born_on: patient_identification.born_on,
            died_at: patient_identification.died_at,
            patient_id: rw_patient.id,
            practice_code: hl7_message.practice_code,
            gp_code: hl7_message.gp_code
          )
        end
        # rubocop:enable Metrics/AbcSize

        def find_or_initialize_abridged_patient
          Patients::Abridgement.find_or_initialize_by(
            hospital_number: patient_identification.internal_id
          )
        end

        def find_patient_in_renalware
          ::Renalware::Patient.find_by(
            local_patient_id: patient_identification.internal_id
          ) || NullObject.instance
        end

        def update_primary_care_physician
          return unless rw_patient && hl7_message.gp_code

          rw_patient.update!(
            primary_care_physician: PrimaryCarePhysician.find_by(code: hl7_message.gp_code),
            by: by
          )
        end

        def update_practice
          return unless rw_patient && hl7_message.practice_code

          rw_patient.update!(
            practice: Practice.find_by(code: hl7_message.practice_code),
            by: by
          )
        end
      end
    end
  end
end
