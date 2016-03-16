require "rails_helper"

module Renalware::Feeds
  RSpec.describe MessageParser do
    describe "#parse" do
      context "given a message with multiple observation segments" do
        let(:raw_message) { <<-RAW.strip_heredoc
            MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
            PID|||Z999990^^^PAS Number||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
            PV1||Inpatient|NIBC^^^^^^^^|||||MID^KINGS MIDWIVES||||||||||NHS|HXF888888^^^Visit Number|||||||||
            ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
            OBR|1|123456^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
            OBX|1|TX|WBC^WBC^MB||6.09||||||F|||200911112026||BBKA^Kenneth AMENYAH|
            OBX|2|TX|RBC^RBC^MB||4.00||||||F|||200911112026||BBKA^Kenneth AMENYAH|
          RAW
         }

        it "returns a message" do
          message = subject.parse(raw_message)

          expect(message).to be_a(HL7Message)
        end

        it "assigns the type to the message" do
          message = subject.parse(raw_message)

          expect(message.type).to eq("ORU^R01")
        end

        it "assigns the header ID to the message" do
          message = subject.parse(raw_message)

          expect(message.header_id).to eq("1258271")
        end

        it "assigns the patient identification attributes to the message", :aggregate_failures do
          message = subject.parse(raw_message)

          expect(message.type).to eq("ORU^R01")

          message.patient_identification.tap do |pi|
            expect(pi.internal_id).to eq("Z999990")
            expect(pi.external_id).to eq("")
            expect(pi.family_name).to eq("RABBIT")
            expect(pi.given_name).to eq("JESSICA")
            expect(pi.sex).to eq("F")
            expect(pi.dob).to eq("19880924")
          end
        end

        it "assigns the observation request attributes to the message", :aggregate_failures do
          message = subject.parse(raw_message)

          message.observation_request.tap do |obr|
            expect(obr.identifier).to eq("FBC")
            expect(obr.ordering_provider).to eq("MID^KINGS MIDWIVES")
            expect(obr.placer_order_number).to eq("123456")
            expect(obr.date_time).to eq("200911111841")
          end

          message.observation_request.observations.first.tap do |obs|
            expect(obs.identifier).to eq("WBC")
            expect(obs.comment).to eq("6.09")
            expect(obs.date_time).to eq("200911112026")
            expect(obs.value).to eq("6.09")
          end
        end

        it "assigns the payload to the message" do
          message = subject.parse(raw_message)

          expect(message.to_s).to eq(raw_message)
        end
      end

      context "given a message with a single observation segment" do
        let(:raw_message) { <<-RAW.strip_heredoc
            MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
            PID|||Z999990^^^PAS Number||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
            PV1||Inpatient|NIBC^^^^^^^^|||||MID^KINGS MIDWIVES||||||||||NHS|HXF888888^^^Visit Number|||||||||
            ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
            OBR|1|123456^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
            OBX|1|TX|WBC^WBC^MB||6.09||||||F|||200911112026||BBKA^Kenneth AMENYAH|
          RAW
         }

        it "returns observations as a collection" do
          message = subject.parse(raw_message)

          expect(message.observation_request.observations).to be_a(Array)
        end
      end
    end
  end
end
