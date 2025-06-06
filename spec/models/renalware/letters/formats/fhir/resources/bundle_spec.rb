module Renalware
  module Letters
    module Formats::FHIR
      describe Resources::Bundle do
        subject(:bundle) { described_class.call(arguments) }

        let(:transmission) do
          instance_double(Transports::Mesh::Transmission, letter: letter, uuid: "TRANS1")
        end
        let(:arguments) {
          Arguments.new(transmission: transmission, transaction_uuid: "123")
        }
        let(:patient) { build_stubbed(:patient) }
        let(:letters_patient) { patient.becomes(Letters::Patient) }
        let(:clinics_patient) { patient.becomes(Clinics::Patient) }
        let(:author) { build_stubbed(:user, uuid: "abc") }
        let(:topic) { build(:letter_topic, snomed_document_type: build(:snomed_document_type)) }
        let(:letter) {
          build_stubbed(
            :approved_letter,
            uuid: "LET1",
            patient: letters_patient,
            topic: topic,
            approved_at: Time.zone.parse("2022-01-01 01:01:01"),
            event: build_stubbed(
              :clinic_visit,
              uuid: "222",
              date: "2022-01-01",
              time: "11:01:01",
              patient: clinics_patient
            ),
            archive: build_stubbed(:letter_archive),
            event_id: 99,
            author: author
          ).tap do |let|
            let.build_main_recipient(person_role: :primary_care_physician)
          end
        }

        it do
          expect(bundle.id).to eq(transmission.uuid)
          expected_updated_at = letter.approved_at.utc.iso8601
          expect(bundle.meta.lastUpdated).to eq(expected_updated_at)
          expect(bundle.type).to eq("message")
        end

        describe "#entry" do
          subject(:entry) { bundle.entry }

          it do
            resources = entry.map { it.resource.class.name }

            expect(resources).to include(
              "FHIR::STU3::MessageHeader",
              "FHIR::STU3::Organization"
            )
          end
        end
      end
    end
  end
end
