require "rails_helper"

module Renalware::Pathology
  RSpec.describe MessageCommandParser do
    describe "#parse" do
      let(:message_payload) {
        double(:message_payload, requester_name: "::name::")
      }

      it "transfers attributes from the message payload to the command" do
        command = subject.parse(message_payload)

        expect(command.requester_name).to eq("::name::")
      end
    end
  end
end
