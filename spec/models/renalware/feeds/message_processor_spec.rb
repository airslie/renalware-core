# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/AnyInstance
module Renalware::Feeds
  describe MessageProcessor do
    describe "#call" do
      context "when a message with the same content already exists in feed_messages" do
        it "does not raise an error or notify the exception" do
          message_processor = described_class.new
          allow(Renalware::Engine.exception_notifier).to receive(:notify)
          allow_any_instance_of(PersistMessage)
            .to receive(:call)
            .and_raise(DuplicateMessageError.new)

          expect { message_processor.call("raw_hl7") }.not_to raise_error
          expect(Renalware::Engine.exception_notifier).not_to have_received(:notify)
        end
      end

      context "when persisting a message raise some other kind of error" do
        it "notifies the exception and re-raises it" do
          message_processor = described_class.new
          allow(Renalware::Engine.exception_notifier).to receive(:notify)
          allow_any_instance_of(PersistMessage)
            .to receive(:call)
            .and_raise(ArgumentError.new)

          expect { message_processor.call("raw_hl7") }.to raise_error(ArgumentError)
          expect(Renalware::Engine.exception_notifier).to have_received(:notify)
        end
      end
    end
  end
end
# rubocop:enable RSpec/AnyInstance
