# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    module Delivery::TransferOfCare
      describe Sections::GPPractice do
        subject(:section) { described_class.new(arguments) }

        let(:transmission) { instance_double(Transmission, letter: letter) }
        let(:arguments) { Arguments.new(transmission: transmission, transaction_uuid: "123") }
        let(:patient) { build_stubbed(:letter_patient, secure_id: "123") }
        let(:letter) do
          build_stubbed(
            :letter,
            patient: patient,
            archive: build_stubbed(:letter_archive)
          ).tap do |lett|
            lett.build_main_recipient(person_role: :primary_care_physician)
          end
        end

        before do
          allow(Renalware.config).to receive(:toc_organisation_uuid).and_return("xyz")
        end

        it { expect(section.snomed_code).to eq("886711000000101") }
        it { expect(section.title).to eq("GP practice") }
        it { expect(section.entries).to eq([{ reference: "urn:uuid:xyz" }]) }
        it { expect(section.render?).to be(true) }
        it { expect(section.call).not_to be_nil }
      end
    end
  end
end
