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

      it "generates an MD5 hash of the payload which should be unique and therefore "\
         "prevent duplicate" do
        service.call(message_payload)

        expect(Message.first.body_hash).to eq(Digest::MD5.hexdigest("::message body::"))
      end

      it "causes a database unique constraint violation if the same message body is saved twice" do
        service.call(message_payload)

        expect{ service.call(message_payload) }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
