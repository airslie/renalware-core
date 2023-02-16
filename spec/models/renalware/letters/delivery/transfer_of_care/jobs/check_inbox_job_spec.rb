# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters::Delivery::TransferOfCare
  describe Jobs::CheckInboxJob do
    include FaradayHelper

    context "when there are no messages in the inbox" do
      let(:response) {  mock_faraday_response(body: { "messages" => [] }) }

      it "checks the inbox and does nothing else" do
        allow(API::Client).to receive(:check_inbox).and_return(response)
        allow(Jobs::DownloadMessageJob).to receive(:perform_later)

        described_class.new.perform

        expect(API::Client).to have_received(:check_inbox)
        expect(Jobs::DownloadMessageJob).not_to have_received(:perform_later)
      end
    end

    context "when there are messages waiting in the inbox" do
      let(:response) { mock_faraday_response(body: { "messages" => %w(123 456) }) }

      it "spawns a new job to download the messages asynchronously" do
        allow(API::Client).to receive(:check_inbox).and_return(response)
        allow(Jobs::DownloadMessageJob).to receive(:perform_later)

        described_class.new.perform

        expect(API::Client).to have_received(:check_inbox)
        expect(Jobs::DownloadMessageJob).to have_received(:perform_later).with("123").once
        expect(Jobs::DownloadMessageJob).to have_received(:perform_later).with("456").once
      end
    end

    context "when there are > 500 messages waiting in the queue" do
      it "uses a batch to download them"
    end
  end
end
