# frozen_string_literal: true

require "renalware/feeds"
require "attr_extras"

module Renalware
  module Patients
    module Ingestion
      class UpdateMasterPatientIndex
        pattr_initialize :hl7_message
        delegate :patient_identification, to: :hl7_message

        def self.call(hl7_message)
          new(hl7_message).call
        end

        def call
          return unless hl7_message.adt?

          update_or_create_abridged_patient
        end

        private

        def update_or_create_abridged_patient
          find_or_initialize_abridged_patient.update!(
            given_name: patient_identification.given_name,
            family_name: patient_identification.family_name,
            sex: patient_identification.sex,
            title: patient_identification.title,
            born_on: patient_identification.born_on,
            died_at: patient_identification.died_at
          )
        end

        def find_or_initialize_abridged_patient
          Patients::Abridgement.find_or_initialize_by(
            hospital_number: patient_identification.internal_id
          )
        end
      end
    end
  end
end
