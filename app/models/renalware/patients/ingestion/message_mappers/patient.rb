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
              local_patient_id: hospital_number,
              nhs_number: message.patient_external_id,
              given_name: message.patient_given_name,
              family_name: message.patient_family_name,
              # middle_name: message.patient_middle_initial_or_name,
              suffix: message.patient_suffix,
              title: message.patient_prefix,
              born_on: Time.zone.parse(message.patient_date_time_of_birth).to_date,
              died_on: Time.zone.parse(message.patient_date_time_of_death),
              sex: message.patient_sex
              # ,
              # practice_code: message.practice_code,
              # gp_code: message.gp_code,
              # source: source
            }
          end
          # rubocop:enable Metrics/AbcSize

          def hospital_number
            message.patient_internal_id
          end
        end
      end
    end
  end
end
