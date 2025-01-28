module Renalware
  module Feeds
    describe ProcessRawHL7MessagesJob do
      let(:instance) { described_class.new }
      let(:message_processor) { instance_double(MessageProcessor, call: nil) }

      let(:raw_hl7_message_1) { create(:raw_hl7_message, body: "FIR\rST\r_M") }
      let(:raw_hl7_message_2) { create(:raw_hl7_message, body: "SECOND_M") }

      before do
        raw_hl7_message_1 && raw_hl7_message_2

        allow(ProcessRawHL7MessageJob).to receive(:perform_now)
      end

      describe "#perform" do
        it "calls out to the message processor" do
          described_class.perform_now

          expect(ProcessRawHL7MessageJob)
            .to have_received(:perform_now)
            .with(message: "FIR\nST\n_M")

          expect(ProcessRawHL7MessageJob)
            .to have_received(:perform_now)
            .with(message: "SECOND_M")

          expect(RawHL7Message.count).to eq 0
        end
      end
    end
  end
end
