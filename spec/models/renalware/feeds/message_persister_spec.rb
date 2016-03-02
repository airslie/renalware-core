require 'rails_helper'

module Renalware::Feeds
  RSpec.describe MessagePersister do
    describe "#call" do
      let(:message_payload) { spy(:message_payload) }

      it "persists the payload" do
        expect{ subject.call(message_payload) }.to change{ Message.count }.by(1)
      end
    end
  end
end
