# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Feeds
    describe ReplayableHL7PathologyMessagesQuery do
      let(:nhs_num) { "4001540037" }
      let(:dob) { Date.parse("2001-01-01") }

      def create_message(
        nhs_number: nil,
        body: "some-hl7#{Time.zone.now.to_i}",
        created_at: Time.zone.now,
        processed: false,
        **
      )
        Message.create!(
          nhs_number: nhs_number,
          message_type: :ORU,
          event_type: :R01,
          orc_order_status: "CM",
          header_id: 1,
          body: body,
          created_at: created_at,
          updated_at: created_at,
          processed: processed,
          **
        )
      end

      it "finds messages by nhs_number + DOB (oldest first) if local_patient_ids don't match" do
        patient = build(:patient, nhs_number: nhs_num, born_on: dob)
        create_message(nhs_number: "nomatch")
        msg_matched1 = create_message(nhs_number: nhs_num, created_at: 1.day.ago, dob: dob)
        msg_matched2 = create_message(
          nhs_number: nhs_num,
          created_at: 2.days.ago,
          dob: dob,
          local_patient_id: "does not match patient's local_patient_id",
          local_patient_id_2: "does not match patient's local_patient_id_2"
        )

        results = described_class.new(patient: patient).call

        expect(results).to eq([msg_matched2, msg_matched1])
      end

      describe "matrix of patient <=> feed_message match conditions" do
        [
          {
            comment: "no matching data",
            patient: { nhs_number: "a", born_on: "2001-01-01" },
            feed_message: { nhs_number: "b", dob: "111-01-01" },
            match: false
          },
          {
            comment: "nhs_number match, dob match, but orc_order_status is not CM",
            patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
            feed_message: { nhs_number: "4001540037", dob: "2001-01-01", orc_order_status: "A" },
            match: false
          },
          {
            comment: "nhs_number match, dob match, but message_type is not ORU",
            patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
            feed_message: { nhs_number: "4001540037", dob: "2001-01-01", message_type: "ADT" },
            match: false
          },
          {
            comment: "nhs_number match, dob match, but event_type is not R01",
            patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
            feed_message: { nhs_number: "4001540037", dob: "2001-01-01", event_type: "A01" },
            match: false
          },
          {
            comment: "nhs_number match, dob match",
            patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
            feed_message: { nhs_number: "4001540037", dob: "2001-01-01" },
            match: true
          },
          {
            comment: "nhs_number match, dob match, note processed: false",
            patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
            feed_message: { nhs_number: "4001540037", dob: "2001-01-01", processed: false },
            match: true
          },
          {
            comment: "nhs_number match, dob match, note processed: nil",
            patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
            feed_message: { nhs_number: "4001540037", dob: "2001-01-01", processed: nil },
            match: true
          },
          {
            comment: "nhs_number match, dob match",
            patient: { nhs_number: "4001540037", born_on: "2001-01-01" },
            feed_message: { nhs_number: "4001540037", dob: "2001-01-01", processed: true },
            match: false
          },
          {
            comment: "no nhs_number match, dob match",
            patient: { nhs_number: "1111111111", born_on: "2001-01-01" },
            feed_message: { nhs_number: "4001540037", dob: "2001-01-01" },
            match: false
          },
          {
            comment: "nhs_number match, dob no match",
            patient: { nhs_number: "4001540037", born_on: "1111-01-01" },
            feed_message: { nhs_number: "4001540037", dob: "2001-01-01" },
            match: false
          },
          {
            comment: "no nhs_number match, dob match, local_patient_id match",
            patient: { nhs_number: "4001540037", born_on: "2001-01-01", local_patient_id: "123" },
            feed_message: { nhs_number: "nomatch", dob: "2001-01-01", local_patient_id: "123" },
            match: true
          },
          {
            comment: "no nhs_number match, dob match, local_patient_id_2 match",
            patient: { nhs_number: "", born_on: "2001-01-01", local_patient_id_2: "222" },
            feed_message: { nhs_number: "nomatch", dob: "2001-01-01", local_patient_id_2: "222" },
            match: true
          },
          {
            comment: "no nhs_number match, dob match, local_patient_id_3 match",
            patient: { nhs_number: "", born_on: "2001-01-01", local_patient_id_3: "333" },
            feed_message: { nhs_number: "nomatch", dob: "2001-01-01", local_patient_id_3: "333" },
            match: true
          },
          {
            comment: "no nhs_number match, dob match, local_patient_id_4 match",
            patient: { nhs_number: "", born_on: "2001-01-01", local_patient_id_4: "444" },
            feed_message: { nhs_number: "nomatch", dob: "2001-01-01", local_patient_id_4: "444" },
            match: true
          }
        ].each do |example|
          it example[:comment] do
            patient = build(:patient, local_patient_id: nil, **example[:patient])
            message = create_message(**example[:feed_message])

            results = described_class.new(patient: patient).call

            if example[:match]
              expect(results).to eq([message])
            else
              expect(results).to be_empty
            end
          end
        end
      end

      it "does not find messages that are already processed" do
        patient = build(:patient, nhs_number: nhs_num, born_on: dob)
        create_message(nhs_number: "nomatch", dob: dob) # no hit
        create_message(nhs_number: nhs_num, dob: dob, processed: true) # a miss as processed is true
        unprocessed_msg1 = create_message(nhs_number: nhs_num, dob: dob, processed: nil)
        unprocessed_msg2 = create_message(nhs_number: nhs_num, dob: dob, processed: false)

        results = described_class.new(patient: patient).call

        expect(results).to contain_exactly(unprocessed_msg1, unprocessed_msg2)
      end

      %i(
        local_patient_id
        local_patient_id_2
        local_patient_id_3
        local_patient_id_4
        local_patient_id_5
      ).each do |local_id_attribute|
        it "finds messages by a patient's #{local_id_attribute} if an nhs_number also matches" do
          hospno = local_id_attribute.to_s.upcase
          patient = build(:patient, nhs_number: nhs_num, local_id_attribute => hospno)
          # This message is for another patient and will never be found
          create_message(local_id_attribute => "nomatch")
          # These 2 messages will be returned, oldest first
          msg_matched2 = create_message(
            local_id_attribute => hospno,
            nhs_number: nhs_num,
            created_at: 2.days.ago
          )
          msg_matched1 = create_message(
            local_id_attribute => hospno,
            nhs_number: nhs_num,
            created_at: 1.day.ago
          )

          results = described_class.call(patient: patient)

          expect(results.to_a).to eq([msg_matched2, msg_matched1])
        end
      end

      context "when there was a previous successful replay for a message" do
        it "excludes that message" do
          patient = build(:patient, nhs_number: nhs_num, born_on: dob)
          msg = create_message(nhs_number: nhs_num, dob: dob, processed: false)
          replay_request = ReplayRequest.create!(started_at: Time.zone.now)
          replay_request.message_replays.create!(message: msg, success: false)

          results = described_class.new(patient: patient).call

          expect(results).to contain_exactly(msg)
        end
      end

      context "when there was a previous unsuccessful replay for a message" do
        it "will include that message" do
          patient = build(:patient, nhs_number: nhs_num, born_on: dob)
          msg = create_message(nhs_number: nhs_num, dob: dob, processed: false)
          replay_request = ReplayRequest.create!(started_at: Time.zone.now)
          replay_request.message_replays.create!(message: msg, success: true)

          results = described_class.new(patient: patient).call

          expect(results).to be_empty
        end
      end
    end
  end
end
