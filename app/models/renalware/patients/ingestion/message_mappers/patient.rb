# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    module Ingestion
      module MessageMappers
        class Patient < MessageMapper
          def initialize(message, patient = nil)
            @patient = patient || Patients::Patient.new

            super(message)
          end

          attr_reader :patient

          def fetch
            map_attributes
            patient
          end

          private

          # rubocop:disable Metrics/AbcSize
          def map_attributes
            patient.attributes = {
              local_patient_id: message.patient_identification.internal_id,
              nhs_number: message.patient_identification.external_id,
              given_name: message.patient_identification.given_name,
              family_name: message.patient_identification.family_name,
              # middle_name: message.patient_middle_initial_or_name,
              suffix: message.patient_identification.suffix,
              title: message.patient_identification.title,
              born_on: Time.zone.parse(message.patient_identification.dob).to_date,
              died_on: Time.zone.parse(message.patient_identification.death_date),
              sex: message.patient_identification.sex
              # ,
              # practice_code: message.practice_code,
              # gp_code: message.gp_code,
              # source: source
            }
          end
          # rubocop:enable Metrics/AbcSize
        end
      end
    end
  end
end
