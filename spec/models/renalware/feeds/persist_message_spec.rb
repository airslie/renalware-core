# frozen_string_literal: true

require "rails_helper"

module Renalware::Feeds
  RSpec.describe PersistMessage do
    subject(:service) { described_class.new }

    describe "#call" do
      let(:message_payload) {
        double(
          :message_payload,
          type: "::message type code::",
          header_id: "::header id::",
          to_s: "::message body::"
        )
      }

      it "persists the payload" do
        expect{ service.call(message_payload) }.to change(Message, :count).by(1)
      end
    end
  end
end
