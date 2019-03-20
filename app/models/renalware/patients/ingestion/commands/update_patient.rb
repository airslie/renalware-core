# frozen_string_literal: true

require_dependency "renalware/patients/ingestion/command"

module Renalware
  module Patients
    module Ingestion
      module Commands
        class UpdatePatient < Command
          def initialize(message, mapper_factory: MessageMapper::Patient)
            @mapper_factory = mapper_factory

            super(message)
          end

          attr_reader :mapper_factory

          def call
            patient = find_patient
            patient = mapper_factory.new(message, patient).fetch
            patient.save!

            patient
          end

          private

          def find_patient
            Patients::Patient.find_or_initialize_by(
              hospital_number: message.patient_internal_id
            )
          end
        end
      end
    end
  end
end
