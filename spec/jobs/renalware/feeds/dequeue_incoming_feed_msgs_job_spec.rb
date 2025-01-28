module Renalware
  module Feeds
    describe DequeueIncomingFeedMsgsJob do
      include ActiveJob::TestHelper

      it { expect(described_class).to respond_to(:perform_later) }

      describe "#perform" do
        it "dequeues waiting feed_msg_ids from feed_msg_queue and, for each one, enqueues a " \
           "new job to process" do
          args = { message_type: "ADT", event_type: "A01", sent_at: Time.zone.now, body: "msg1" }
          msg1 = Msg.create!(args.update(message_control_id: SecureRandom.uuid))
          msg2 = Msg.create!(args.update(message_control_id: SecureRandom.uuid))

          MsgQueue.create!(feed_msg_id: msg1.id)
          MsgQueue.create!(feed_msg_id: msg2.id)

          expect {
            described_class.perform_now
          }
            .to change(MsgQueue, :count).by(-2)
            .and change(enqueued_jobs, :count).by(2)

          expect(Renalware::Feeds::ProcessFeedMsgJob).to(have_been_enqueued.once.with(msg1.id))
          expect(Renalware::Feeds::ProcessFeedMsgJob).to(have_been_enqueued.once.with(msg2.id))
        end
      end
    end
  end
end
