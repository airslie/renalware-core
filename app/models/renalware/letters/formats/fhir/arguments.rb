# frozen_string_literal: true

module Renalware
  module Letters::Formats::FHIR
    # 'Parameter Object' Passed to any class rendering part of a FHIR document message.
    # Provides access to a variety of data but without having any business logic.
    class Arguments
      include Renalware::UniformResourceNaming

      rattr_initialize [:transmission!, :transaction_uuid!]

      delegate :letter, to: :transmission
      delegate :uuid, to: :transmission, prefix: true
      delegate :patient, :event, :archive, to: :letter
      delegate :pdf_content, to: :archive
      delegate :uuid, to: :letter, prefix: true
      alias :clinic_visit :event

      def workflow = Renalware.config.letters_mesh_workflow
      def gp_connect? = workflow == :gp_connect
      def transmission_urn = uuid_urn(transmission_uuid)
      def transaction_urn = uuid_urn(transaction_uuid)
      def letter_urn = uuid_urn(letter_uuid)
      def patient_urn = uuid_urn(patient_uuid)
      def encounter_urn = uuid_urn(encounter_uuid)
      def author_urn = uuid_urn(author_uuid)
      def organisation_urn = uuid_urn(organisation_uuid)
      def organisation_uuid = Renalware.config.mesh_organisation_uuid
      def organisation_ods_code = Renalware.config.mesh_organisation_ods_code
      def patient_uuid = patient.secure_id_dashed
      def author_uuid = letter.author.uuid
      def binary_uuid = archive.uuid
      def binary_urn = uuid_urn(binary_uuid)

      def encounter_uuid
        @encounter_uuid ||= clinic_visit&.uuid || SecureRandom.uuid
      end
    end
  end
end
