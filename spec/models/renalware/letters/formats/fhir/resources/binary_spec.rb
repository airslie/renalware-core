# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    module Formats::FHIR
      describe Resources::Binary do
        subject(:binary) { described_class.call(arguments) }

        let(:transmission) do
          instance_double(Transports::Mesh::Transmission, letter: letter, uuid: "TRANS1")
        end
        let(:binary_uuid) { SecureRandom.uuid }
        let(:arguments) { Arguments.new(transmission: transmission, transaction_uuid: "123") }
        let(:patient) { build_stubbed(:patient) }
        let(:letters_patient) { patient.becomes(Letters::Patient) }
        let(:author) { build_stubbed(:user, uuid: "abc") }
        let(:letter) {
          build_stubbed(
            :approved_letter,
            uuid: "LET1",
            patient: letters_patient,
            updated_at: Time.zone.parse("2022-01-01 01:01:01"),
            event_id: 99,
            author: author,
            archive: build_stubbed(:letter_archive, uuid: binary_uuid, pdf_content: "123")
          ).tap do |let|
            let.build_main_recipient(person_role: :primary_care_physician)
          end
        }

        it do
          expect(binary[:resource].id).to eq(binary_uuid)
          expect(binary[:resource].contentType).to eq("application/pdf")
          expect(binary[:resource].content).to eq(Base64.encode64("123"))
        end
      end
    end
  end
end
