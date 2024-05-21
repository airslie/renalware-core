# frozen_string_literal: true

require "rails_helper"

X = Renalware::Letters::Transports::Mesh::Transmission

module Renalware
  module Letters
    module Formats::FHIR
      describe Resources::GPConnect::Composition do
        subject(:composition) { described_class.call(arguments) }

        let(:transmission) do
          instance_double(Transports::Mesh::Transmission, letter: letter, uuid: "TRANS1")
        end
        let(:arguments) { Arguments.new(transmission: transmission, transaction_uuid: "123") }
        let(:resource) { composition[:resource] }
        let(:patient) { build_stubbed(:patient) }
        let(:author) { build_stubbed(:user, uuid: "abc") }
        let(:clinic_visit) { build_stubbed(:clinic_visit, patient: Clinics.cast_patient(patient)) }
        let(:letter_patient) { patient.becomes(Letters::Patient) }
        let(:letter) {
          build_stubbed(
            :approved_letter,
            archive: build_stubbed(:letter_archive),
            patient: letter_patient,
            updated_at: Time.zone.parse("2022-01-01 01:01:01"),
            event: clinic_visit,
            event_id: 99,
            author: author
          ).tap do |let|
            let.build_main_recipient(person_role: :primary_care_physician)
          end
        }

        before do
          allow(author).to receive(:uuid).and_return("abc")
          allow(letter).to receive_messages(uuid: "LET1", event: clinic_visit)
          allow(letter_patient).to receive(:secure_id_dashed).and_return("PAT1")
          allow(clinic_visit).to receive(:uuid).and_return("CV_ENCOUNTER_1")
        end

        describe "fullUrl" do
          subject { composition[:fullUrl] }

          it "is the urn of the letter" do
            is_expected.to eq("urn:uuid:LET1")
          end
        end

        describe "resource" do
          subject(:resource) { composition[:resource] }

          it "id is the message id (a UUID in the database)" do
            expect(resource.id).to eq(letter.uuid)
          end

          it "subject references the patient urn" do
            expect(resource.subject.reference).to eq("urn:uuid:PAT1")
          end

          it "includes the letter updated_at" do
            expect(resource.date).to eq("2022-01-01T01:01:01+00:00")
          end

          it "references the letter author" do
            expect(resource.author.first.reference).to eq("urn:uuid:abc")
          end

          it "has the correct snomed code" do
            expect(resource.type.coding.first.code).to eq("823681000000100")
            expect(resource.type.coding.first.display).to eq("Outpatient letter")
          end

          it "has correct sections" do
            puts resource.to_xml
            section = resource.section[0]
            expect(section.entry[0].reference).to eq arguments.organisation_urn
            expect(section.entry[1].reference).to eq arguments.author_urn
            expect(section.entry[2].reference).to eq arguments.patient_urn
            expect(section.entry[3].reference).to eq arguments.binary_urn
          end
        end
      end
    end
  end
end
