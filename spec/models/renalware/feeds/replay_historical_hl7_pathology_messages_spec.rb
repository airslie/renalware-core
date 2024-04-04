# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Feeds
    describe ReplayHistoricalHL7PathologyMessages do
      let(:hl7) do
        <<-HL7.squish
          MSH|^~\&|HM|RAJ01|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
          PID||7179209791^NHS|Z100002^^^KCH||RABBIT^JESSICA^^^MS||19480922|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR||||||||||||||||||201010102359|
          ORC|RE|0031111111^PCS|18T1111111^LA||CM||||201801221418|||xxx^xx, xxxx
          OBR|1|^PCS|09B0099478^LA|XBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
          OBX|1|TX|CRE^CRE^HM||23||||||F|||201801151249||BHISVC01^BHI Authchecker
        HL7
      end

      context "when feed_messages are replayed successfully" do
        it do
          allow(MessageParser).to receive(:parse).and_return(NullObject.instance)
          patient = create(:patient, nhs_number: "0123456789", born_on: "2001-01-01")
          feed_message = Message.create!(
            nhs_number: "0123456789",
            dob: "2001-01-01",
            body: "test",
            message_type: :ORU,
            event_type: :R01,
            processed: nil,
            orc_filler_order_number: "123",
            sent_at: 1.day.ago,
            header_id: "123"
          )

          freeze_time do
            now = Time.zone.now
            # skip broadcasting_to_configured_subscribers which happens in class.call
            expect {
              described_class.new(patient: patient).call
            }
              .to change(ReplayRequest, :count).by(1)
              .and change(MessageReplay, :count).by(1)

            replay_request = ReplayRequest.last
            expect(replay_request).to have_attributes(
              started_at: now,
              finished_at: now,
              total_messages: 1,
              failed_messages: 0
            )

            expect(replay_request.message_replays.last).to have_attributes(
              message: feed_message,
              success: true,
              error_message: nil
            )
          end
        end

        context "when one feed_message signals an error during replay" do
          # rubocop:disable RSpec/ExampleLength
          it "flags that one as failed" do
            patient = create(:patient, nhs_number: "0123456789", born_on: "2001-01-01")
            feed_message_fail = Message.create!(
              nhs_number: "0123456789",
              dob: "2001-01-01",
              body: "BAD HL7",
              message_type: :ORU,
              event_type: :R01,
              processed: nil,
              orc_order_status: "CM",
              header_id: "123",
              orc_filler_order_number: "123",
              sent_at: 1.day.ago
            )
            feed_message_ok = Message.create!(
              nhs_number: "0123456789",
              dob: "2001-01-01",
              body: hl7,
              message_type: :ORU,
              event_type: :R01,
              processed: nil,
              orc_order_status: "CM",
              header_id: "123",
              orc_filler_order_number: "456",
              sent_at: 1.day.ago
            )
            # allow(MessageParser).to receive(:parse).and_return(NullObject.instance)

            freeze_time do
              now = Time.zone.now
              # skip broadcasting_to_configured_subscribers which happens in class.call
              expect {
                described_class.new(patient: patient).call
              }
                .to change(ReplayRequest, :count).by(1)
                .and change(MessageReplay, :count).by(2)

              expect(ReplayRequest.last).to have_attributes(
                started_at: now,
                finished_at: now,
                total_messages: 2,
                failed_messages: 1
              )

              expect(MessageReplay.first).to have_attributes(
                success: false,
                message: feed_message_fail,
                error_message: /undefined method `message_type' for nil/
              )

              expect(MessageReplay.last).to have_attributes(
                success: true,
                message: feed_message_ok,
                error_message: nil
              )
            end
            # rubocop:enable RSpec/ExampleLength
          end
        end
      end
    end
  end
end
