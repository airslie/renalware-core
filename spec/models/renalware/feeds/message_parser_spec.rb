require "rails_helper"

module Renalware::Feeds
  RSpec.describe MessageParser do
    describe "#parse" do
       let(:raw_message) { <<-RAW
MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
PID|||Z999990^^^PAS Number||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
PV1||Inpatient|NIBC^^^^^^^^|||||MID^KINGS MIDWIVES||||||||||NHS|HXF888888^^^Visit Number|||||||||
ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
OBR|1|123456^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
OBX|1|TX|WBC^WBC^MB||6.09||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|2|TX|RBC^RBC^MB||4.00||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|3|TX|HB^Hb^MB||11.8||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|4|TX|PCV^PCV^MB||0.344||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|5|TX|MCV^MCV^MB||85.9||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|6|TX|MCH^MCH^MB||29.5||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|7|TX|MCHC^MCHC^MB||34.4||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|8|TX|RDW^RDW^MB||13.3||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|9|TX|PLT^PLT^MB||259||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|10|TX|MPV^Mean Platelet Volume^MB||8.3||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|11|TX|NRBC^Machine NRBC^MB||<0.2%||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|12|TX|HYPO^% HYPO^MB||0.2||||||F|||200911112026||BBKA^Kenneth AMENYAH|
OBX|13|TX|NEUT^Neutrophil Count^MB||  3.16||||||F|||200911121646||BHISVC01^BHI Authchecker|
OBX|14|TX|LYM^Lymphocyte Count^MB||  2.32||||||F|||200911121646||BHISVC01^BHI Authchecker|
OBX|15|TX|MON^Monocyte Count^MB||  0.44||||||F|||200911121646||BHISVC01^BHI Authchecker|
OBX|16|TX|EOS^Eosinophil Count^MB||  0.15||||||F|||200911121646||BHISVC01^BHI Authchecker|
OBX|17|TX|BASO^Basophils^MB||  0.02||||||F|||200911121646||BHISVC01^BHI Authchecker|
        RAW
       }

      it "returns a message" do
        message = subject.parse(raw_message)

        expect(message).to be_a(MessageWrapper)
      end

      it "assigns the attributes to the message", :aggregate_failures do
        message = subject.parse(raw_message)

        expect(message.type).to eq("ORU^R01")
        expect(message.observation_request.ordering_provider).to eq("MID^KINGS MIDWIVES")
        expect(message.observation_request.placer_order_number).to eq("123456")
        expect(message.observation_request.observation_date_time).to eq("200911111841")
        expect(message.observation_request.observations.first.comment).to eq("6.09")
        expect(message.observation_request.observations.first.observation_date_time).to eq("200911112026")
      end

      it "assigns the payload to the message" do
        message = subject.parse(raw_message)

        expect(message.to_s).to eq(raw_message)
      end
    end
  end
end
