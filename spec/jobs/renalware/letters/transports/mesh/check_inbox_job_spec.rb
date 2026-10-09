module Renalware::Letters::Transports::Mesh
  describe CheckInboxJob do
    include FaradayHelper

    let(:perform) { -> { described_class.new.perform } }

    context "when there are no messages in the inbox" do
      let(:response) { mock_faraday_response(body: { "messages" => [] }) }

      it "checks the inbox and does nothing else" do
        allow(API::Client).to receive(:check_inbox).and_return(response)

        expect(perform).not_to have_enqueued_job(DownloadMessageJob)

        expect(API::Client).to have_received(:check_inbox)
      end
    end

    context "when there are messages waiting in the inbox" do
      let(:response) { mock_faraday_response(body: { "messages" => %w(123 456) }) }

      it "spawns a new job to download the messages asynchronously" do
        allow(API::Client).to receive(:check_inbox).and_return(response)

        expect(perform)
          .to have_enqueued_job(DownloadMessageJob).with("123").once
          .and have_enqueued_job(DownloadMessageJob).with("456").once

        expect(API::Client).to have_received(:check_inbox)
      end
    end

    context "when there are > 500 messages waiting in the queue" do
      it "uses a batch to download them"
    end
  end
end
