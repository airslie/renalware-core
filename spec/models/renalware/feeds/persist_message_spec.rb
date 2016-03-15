require "rails_helper"

module Renalware::Feeds
  RSpec.describe PersistMessage do
    describe "#call" do
      let(:message_payload) {
        double(:message_payload,
          type: "::message type code::",
          header_id: "::header id::",
          to_s: "::message body::"
        )
      }

      it "persists the payload" do
        expect{ subject.call(message_payload) }.to change{ Message.count }.by(1)
      end
    end
  end
end
