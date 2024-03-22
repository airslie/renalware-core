# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    module Formats
      module FHIR
        describe Resources::MessageHeader do
          subject(:message_header) { described_class.call(arguments) }

          let(:transmission) { instance_double(Transports::Mesh::Transmission, letter: letter) }
          let(:arguments) { Arguments.new(transmission: transmission, transaction_uuid: "123") }
          let(:patient) { Renalware::Patient.new(secure_id: "456") }
          let(:letter) { instance_double(Letter, patient: patient, uuid: "789") }

          describe "#resource" do
            subject(:resource) { message_header[:resource] }

            it "BusAckRequested is true" do
              expect(resource.extension[0].extension[0].url).to eq("BusAckRequested")
              expect(resource.extension[0].extension[0].valueBoolean).to be(true)
            end

            it "InfAckRequested is true" do
              expect(resource.extension[0].extension[1].url).to eq("InfAckRequested")
              expect(resource.extension[0].extension[1].valueBoolean).to be(true)
            end

            it "has an event describing the message" do
              coding = message_header[:resource].event.first
              expect(coding.code).to eq("ITK006D") # ITK3-MessageEvent
              expect(coding.display).to eq("ITK Outpatient Letter")
            end

            it "source specifies our mailbox id" do
              allow(Renalware.config).to receive(:mesh_mailbox_id).and_return("ABC123")
              expect(resource.source.endpoint).to eq("ABC123")
            end
          end
        end
      end
    end
  end
end
