# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters::Delivery::TransferOfCare
  describe Arguments do
    subject(:arguments) do
      described_class.new(transmission: transmission, transaction_uuid: transaction_uuid)
    end

    let(:transmission) {
      build_stubbed(
        :letter_toc_transmission,
        letter: letter
      )
    }
    let(:transaction_uuid) { SecureRandom.uuid }
    let(:patient_uuid) { "aaaabe8f-8694-47e3-8740-ccf306f6cf02" }
    let(:letter_uuid) { "aaaa54bb-adfb-452e-a829-c50a42709080" }
    let(:author_uuid) { "aaaa4316-1daa-4c41-91c9-a8d0ea6ceb5e" }
    let(:clinic_visit_uuid) { "aaaaf1a9-0c1c-4151-b947-7d9e7fce0a75" }
    let(:patient) { build_stubbed(:letter_patient, secure_id: patient_uuid) }
    let(:clinics_patient) { Renalware::Clinics.cast_patient(patient) }
    let(:letter) {
      build_stubbed(
        :letter,
        uuid: letter_uuid,
        patient: patient,
        author: build_stubbed(:user, uuid: author_uuid),
        event: build_stubbed(
          :clinic_visit,
          uuid: clinic_visit_uuid,
          patient: clinics_patient
        )
      )
    }

    describe "patient_urn" do
      it do
        expect(arguments.patient_urn).to eq("urn:uuid:#{patient_uuid}")
      end
    end

    describe "letter_urn" do
      it do
        expect(arguments.letter_urn).to eq("urn:uuid:#{letter.uuid}")
      end
    end

    describe "author_urn" do
      it do
        expect(arguments.author_urn).to eq("urn:uuid:#{author_uuid}")
      end
    end

    # describe "encounter_urn" do
    #   it "is nil when there is no clinic visit for this letter" do
    #     allow(letter).to receive(:event).and_return(nil)

    #     expect(arguments.encounter_urn).to be_nil
    #   end

    #   it "returns the clinic_visit.uuid if this the letter is associated with a clinic" do
    #     expect(arguments.encounter_urn).to eq("urn:uuid:#{clinic_visit_uuid}")
    #   end
    # end

    describe "organisation_uuid" do
      it "is read from config" do
        allow(Renalware.config).to receive(:toc_organisation_uuid).and_return("123")

        expect(arguments.organisation_uuid).to eq("123")
      end
    end

    describe "organisation_urn" do
      it "is derived from config" do
        allow(Renalware.config).to receive(:toc_organisation_uuid).and_return("123")

        expect(arguments.organisation_urn).to eq("urn:uuid:123")
      end
    end

    describe "organisation_ods_code" do
      it "is read from config" do
        allow(Renalware.config).to receive(:toc_organisation_ods_code).and_return("ABC")

        expect(arguments.organisation_ods_code).to eq("ABC")
      end
    end
  end
end
