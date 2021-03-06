# frozen_string_literal: true

require_dependency "renalware/patients/ingestion/command"

module Renalware
  module Patients
    module Ingestion
      module Commands
        # We could be here as a results of 2 scenarios:
        # - ADT28 add patient
        # - ADT31 update patient
        #
        # In both circumstances our action is the same:
        # 1. If the patient exists as a Renalware::Patient, update their details
        # 2. Find or create a Patients::Abridgement for this patient
        # 3. Update their abridgement info, including their Renalware::Patient id if one exists
        #
        # So basically we are maintaining patient data in 2 places:
        # a) in Renalware::Patient and its associated address and demographics tables
        # b) in Renalware::Patients::Abrigement, which is an abbreviated version of the patient's
        #    details (name, numbers, DOB ect), enabling us to find and import a new patient by
        #    taking the abridgement, finding all previously received ADT and ORU etc feed_messages
        #    for the patient and replaying those messages to build the patient with their
        #    and pathology. If a patient is already a Renalware::Patient then in theory we do
        #    not need to maintain an abridgement for them, but for consistentency we do; it has
        #    advantages when trying to add a new patient in the Renalware UI - e.g. it can show you
        #    that that patient is already added because there is a patient_id on the abridgement.
        class AddOrUpdatePatient < Command
          def initialize(message, mapper_factory: MessageMappers::Patient)
            @mapper_factory = mapper_factory

            super(message)
          end

          attr_reader :mapper_factory

          def call
            update_patient_if_exists
            UpdateMasterPatientIndex.new(message).call
          end

          private

          def update_patient_if_exists
            return if ENV.key?("ADT_SKIP_UPDATE_PATIENT")

            patient = find_patient
            return if patient.blank?

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

          def find_patient
            Patient.find_by(
              local_patient_id: message.patient_identification.internal_id
            )
          end
        end
      end
    end
  end
end
