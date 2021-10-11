# frozen_string_literal: true

require_dependency "renalware/patients/ingestion/command"

module Renalware
  module Patients
    module Ingestion
      module Commands
        class AddPatient < Command
          def initialize(message, mapper_factory: MessageMappers::Patient)
            @mapper_factory = mapper_factory

            super(message)
          end

          def call
            patient = add_patient_if_not_exists
            UpdateMasterPatientIndex.call(message)
            patient
          end

          private

          attr_reader :mapper_factory

          def add_patient_if_not_exists
            return if ENV.key?("ADT_SKIP_UPDATE_PATIENT")

            patient = find_patient
            return if patient.present?

            patient = mapper_factory.new(message, patient).fetch
            patient.by = SystemUser.find
            # If we update a patient who has the Death modality, and they do not have certain
            # fields set yet like cause of death, we don't want those validations so stop us
            # updating - so we set a flag here to effectively skip death attribute validations
            # e.g. Died on can't be blank, Died on is not a valid date, First cause can't be blank
            patient.skip_death_validations = true

            patient.save!
            patient
          end
        end
      end
    end
  end
end
