# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    # 'Parameter Object' Passed to any class rendering part of a ToC document
    # Provides access to a variety of data but without having any business logic.
    class Arguments
      include Renalware::UniformResourceNaming

      rattr_initialize [:transmission!, :transaction_uuid!]

      delegate :letter, to: :transmission
      delegate :uuid, to: :transmission, prefix: true
      delegate :patient, :event, to: :letter
      delegate :uuid, to: :letter, prefix: true
      alias :clinic_visit :event

      def transmission_urn = uuid_urn(transmission_uuid)
      def transaction_urn = uuid_urn(transaction_uuid)
      def letter_urn = uuid_urn(letter_uuid)
      def patient_urn = uuid_urn(patient_uuid)
      def encounter_urn = uuid_urn(encounter_uuid)
      def author_urn = uuid_urn(author_uuid)
      def organisation_urn = uuid_urn(organisation_uuid)
      def organisation_uuid = Renalware.config.toc_organisation_uuid
      def organisation_ods_code = Renalware.config.toc_organisation_ods_code
      def patient_uuid = patient.secure_id_dashed
      def author_uuid = letter.author.uuid

      def encounter_uuid
        @encounter_uuid ||= clinic_visit&.uuid || SecureRandom.uuid
      end
    end
  end
end
