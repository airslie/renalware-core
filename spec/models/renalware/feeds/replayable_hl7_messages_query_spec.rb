# frozen_string_literal: true

require "rails_helper"

# rubocop:disable Layout/LineLength
module Renalware
  module Feeds
    describe ReplayableHL7MessagesQuery do
      let(:sample_nhs_number) { "4001540037" }

      def create_message(
        nhs_number: nil,
        body: "some-hl7",
        created_at: Time.zone.now,
        **opts
      )
        Message.create!(
          nhs_number: nhs_number,
          message_type: :ORU,
          event_type: :R01,
          header_id: 1,
          body: body,
          created_at: created_at,
          updated_at: created_at,
          **opts
        )
      end

      it "raises an error if no message types passed" do
        patient = build(:patient, nhs_number: sample_nhs_number)

        expect {
          described_class.new(patient: patient, message_types: []).call
        }.to raise_error(ReplayableHL7MessagesQuery::MissingMessageTypesError)
      end

      it "raises an error if incorrect message types passed" do
        patient = build(:patient, nhs_number: sample_nhs_number)

        expect {
          described_class.new(patient: patient, message_types: [:RUBBISH]).call
        }.to raise_error(ReplayableHL7MessagesQuery::InvalidMessageTypesError)
      end

      it "finds messages by nhs_number" do
        patient = build(:patient, nhs_number: sample_nhs_number)
        create_message(nhs_number: "nomatch")
        msg_matched1 = create_message(nhs_number: sample_nhs_number, body: "y", created_at: 1.day.ago)
        msg_matched2 = create_message(nhs_number: sample_nhs_number, body: "x", created_at: 2.days.ago)

        results = described_class.new(patient: patient, message_types: :ORU).call

        expect(results).to eq([msg_matched2, msg_matched1])
      end

      %i(
        local_patient_id
        local_patient_id_2
        local_patient_id_3
        local_patient_id_4
        local_patient_id_5
      ).each do |local_id_attribute|
        it "finds messages by a patient's #{local_id_attribute}" do
          hospno = local_id_attribute.to_s.upcase
          patient = build(:patient, nhs_number: nil, local_id_attribute => hospno)
          # This message is for another patient and will never be found
          create_message(local_id_attribute => "nomatch")
          # These 2 messages will be returned, oldest first
          msg_matched2 = create_message(local_id_attribute => hospno, body: "x", created_at: 2.days.ago)
          msg_matched1 = create_message(local_id_attribute => hospno, body: "y", created_at: 1.day.ago)

          results = described_class.call(patient: patient, message_types: :ORU)

          expect(results.to_a).to eq([msg_matched2, msg_matched1])
        end
      end

      context "when the patient has an nhs_number and a local_patient_id" do
        context "when there are two messages, one with a matching nhs_number and one " \
                "with a matching local_patient_id" do
          it "finds both messages" do
            # patient with both an NHS and hospno
            patient = build(:patient, nhs_number: sample_nhs_number, local_patient_id: "P1")
            # This message is for another patient and will never be found
            create_message(local_patient_id: "nomatch", nhs_number: "1741581516")
            # These 2 messages will be returned, oldest first. The first matches on nhs_number and
            # the second matches on local_patient_id
            msg_matched2 = create_message(nhs_number: sample_nhs_number, body: "x", created_at: 2.days.ago)
            msg_matched1 = create_message(local_patient_id: "P1", body: "y", created_at: 1.day.ago)

            results = described_class.new(patient: patient, message_types: :ORU).call

            expect(results.to_a).to eq([msg_matched2, msg_matched1])
          end
        end

        context "when there is a potentially matching message but it's nhs number matches " \
                "but the local_patient_id does not" do
          it "still matches it" do
            # patient with both an NHS and local_patient_id
            patient = build(:patient, nhs_number: sample_nhs_number, local_patient_id: "P1")
            # Note only one number matches
            msg = create_message(nhs_number: sample_nhs_number, local_patient_id: "P2")

            results = described_class.new(patient: patient, message_types: :ORU).call

            expect(results.to_a).to eq([msg])
          end
        end

        context "when there is a potentially matching message but it's local_patient_id matches " \
                "but the nhs_number does not" do
          it "still matches it" do
            # patient with both an NHS and local_patient_id
            patient = build(:patient, nhs_number: sample_nhs_number, local_patient_id: "P1")
            # Note only one number matches
            msg = create_message(nhs_number: "1791963196", local_patient_id: "P1")

            results = described_class.new(patient: patient, message_types: :ORU).call

            expect(results.to_a).to eq([msg])
          end
        end
      end
    end
  end
end
# rubocop:enable Layout/LineLength
