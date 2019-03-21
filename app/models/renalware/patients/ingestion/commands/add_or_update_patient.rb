# frozen_string_literal: true

require_dependency "renalware/patients/ingestion/command"

module Renalware
  module Patients
    module Ingestion
      module Commands
        class AddOrUpdatePatient < Command
          def initialize(message, mapper_factory: MessageMappers::Patient)
            @mapper_factory = mapper_factory

            super(message)
          end

          attr_reader :mapper_factory

          def call
            patient = find_patient
            patient = mapper_factory.new(message, patient).fetch
            patient.by = SystemUser.find
            patient.save!

            patient
          end

          private

          def find_patient
            ::Renalware::Patient.find_or_initialize_by(
              local_patient_id: message.patient_identification.internal_id
            )
          end
        end
      end
    end
  end
end
