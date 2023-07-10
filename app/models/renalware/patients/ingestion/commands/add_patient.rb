# frozen_string_literal: true

module Renalware
  module Patients
    module Ingestion
      module Commands
        class AddPatient < Command
          include Broadcasting

          def self.call(...)
            new(...)
              .broadcasting_to_configured_subscribers
              .call
          end

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
            patient = find_patient
            return patient if patient.present?
            return patient if ENV.key?("ADT_SKIP_UPDATE_PATIENT")

            patient = mapper_factory.new(message, patient).fetch
            patient.by = SystemUser.find
            new_record = patient.new_record?
            patient.save!

            broadcast(:patient_added, patient) if new_record

            patient
          end
        end
      end
    end
  end
end
