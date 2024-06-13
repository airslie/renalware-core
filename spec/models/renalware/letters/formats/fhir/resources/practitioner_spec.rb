# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters
  module Formats::FHIR
    describe Resources::Practitioner do
      subject(:practitioner_resource) { described_class.call(arguments) }

      let(:author) do
        instance_double(
          Renalware::User,
          uuid: "999",
          family_name: "Smith",
          given_name: "John",
          professional_position: "Consultant"
        )
      end

      let(:patient) {
        instance_double(
          Renalware::Patient,
          secure_id_dashed: "111",
          nhs_number: "0123456789",
          local_patient_id: "PID1",
          local_patient_id_2: "PID2",
          local_patient_id_3: "",
          local_patient_id_4: nil,
          given_name: "John",
          family_name: "Doe",
          title: "Mr",
          sex: "M",
          born_on: Date.parse("2001-01-02"),
          current_address: nil,
          telephone1: nil,
          email: nil
        )
      }
      let(:letter) { instance_double(Letter, patient: patient, author: author) }
      let(:arguments) do
        Arguments.new(
          transmission: instance_double(Transports::Mesh::Transmission, letter: letter),
          transaction_uuid: "123"
        )
      end

      it "fullUrl" do
        expect(practitioner_resource[:fullUrl]).to eq("urn:uuid:999")
      end
    end
  end
end
