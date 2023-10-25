# frozen_string_literal: true

# rubocop:disable Style/RaiseArgs
module Renalware
  module Patients
    module Ingestion
      module Commands
        class AddPatient < Command
          class PossibleRaceConditionCreatingPatientError < StandardError; end

          def self.call(...) = new(...).call

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
            return patient if patient.present? || ENV.key?("ADT_SKIP_UPDATE_PATIENT")

            patient = try_create_patient
            BroadcastPatientAddedEvent.call(patient) if patient.new_record?
            patient
          end

          def try_create_patient
            begin
              patient = mapper_factory.new(message, patient).fetch
              patient.by = SystemUser.find
              patient.save!
              patient
            rescue ActiveRecord::RecordNotUnique => e
              # A few moments ago could we not find the patient and now we and now we can't create
              # it due to a RecordNotUnique error... this can only (?) mean there has been race
              # condition to create the patient due to two messages arriving hot on each other's
              # heels... so try to find the patient again and if for any reason we can't then raise
              # a descriptive error.
              patient = find_patient
              raise PossibleRaceConditionCreatingPatientError.new(e) if patient.blank?
            ensure
              patient
            end
          end
        end
      end
    end
  end
end
# rubocop:enable Style/RaiseArgs
