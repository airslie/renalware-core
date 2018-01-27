require "rails_helper"

module Renalware::Pathology
  RSpec.describe MessageParamParser do
    describe "#parse" do
      let(:patient) { create(:patient) }
      let(:observation_description) { create(:pathology_observation_description) }
      let(:request_description) { create(:pathology_request_description) }

      let(:message_payload) {
        double(
          :message_payload,
          patient_identification: double(internal_id: patient.local_patient_id),
          observation_request: double(
            identifier: request_description.code,
            ordering_provider_name: "::name::",
            placer_order_number: "::pcs code::",
            date_time: "200911111841",
            observations: [
              double(
                identifier: observation_description.code,
                date_time: "200911112026",
                value: "::value::",
                comment: "::comment::"
              )
            ]
          )
        )
      }

      it "transfers attributes from the message payload to the params" do
        parser = described_class.new(message_payload)

        expect(parser.renalware_patient?).to be_truthy
        params = parser.parse

        expect(params).to eq(
          {
            patient_id: patient.id,
            observation_request: {
              description_id: request_description.id,
              requestor_name: "::name::",
              requestor_order_number: "::pcs code::",
              requested_at: "2009-11-11 18:41:00 +0000",
              observations_attributes: [
                description_id: observation_description.id,
                observed_at: "2009-11-11 20:26:00 +0000",
                result: "::value::",
                comment: "::comment::"
              ]
            }
          }
        )
      end

      context "when the patient is not found" do
        it "logs a warning fails silently. This is an acceptable outcome "\
           "because most pathology messages will be for non-renal patients, and we ignore them" do
          non_existent_patient = "123123123"
          message_payload = double(
            :message_payload,
            patient_identification: double(internal_id: non_existent_patient),
            observation_request: double(
              identifier: request_description.code,
              ordering_provider_name: "::name::",
              placer_order_number: "::pcs code::",
              date_time: "200911111841",
              observations: [
                double(
                  identifier: observation_description.code,
                  date_time: "200911112026",
                  value: "::value::",
                  comment: "::comment::"
                )
              ]
            )
          )
          logger = instance_double("Rails.logger").as_null_object
          expect(logger).to receive(:debug).once

          parser = described_class.new(message_payload, logger)

          expect(parser.renalware_patient?).to be_falsey
          expect(parser.parse).to be_nil
        end
      end

      context "when the message has > 1 OBR segment" do
        let(:raw_message) do
          <<-RAW.strip_heredoc
            MSH|^~\&|HM|LIVE|SCM||20181212170103||ORU^R01|00002286|P|2.3.1|||AL
            PID|||Z999990^^^PAS Number||XXX^XXX^^^Mr||11110715|M|||ss^ss^^^SE00 600
            PV1||Inpatient|COPK|||||RABRO^Rabbit, Roger||||||||||NHS|ED001332881^^^Visit Number
            ORC|RE|217SC5661^PCS|1010101010^LA||CM||||201801251204|||RABRO^Rabbit, Roger
            OBR|1|217SC5661^PCS|1010101010^LA|RLU^RENAL/LIVER/UREA^HM||201801251204|201801250541||||||.|201801250541|B^Blood|RABRO^Rabbit, Roger||1010101010||||201801251249||HM|F
            OBX|1|NM|NA^Sodium^HM||136|mmol/L|||||F|||201801251249||BHISVC01^BHI Authchecker
            ORC|RE|111111111^PCS|100000000^LA||CM||||201801251204|||RABRO^Rabbit, Roger
            OBR|2|217SC5661^PCS|1010101010^LA|BONE^BONE PROFILE^HM||201801251204|201801250541||||||.|201801250541|B^Blood|RABRO^Rabbit, Roger||1010101010||||201801251700||HM|F
            OBX|1|NM|CCA^Corrected Calc^HM||3.16|mmol/L||H|||F|||201801251700||CBEAA^X Y
          RAW
        end

        it "does not throw `undefined local variable or method `universal_service_id'`" do
          create(:pathology_request_description, code: "RLU")
          create(:pathology_request_description, code: "BONE")
          create(:pathology_observation_description, code: "NA")
          create(:pathology_observation_description, code: "CCA")
          create(:patient, local_patient_id: "Z999990")
          message = Renalware::Feeds::MessageParser.new.parse(raw_message)

          parser = described_class.new(message)

          expect{ parser.parse }.not_to raise_error
        end

        it "creates a params hash with multiple observation_requests" do
          parser = described_class.new(message_payload)
          expect(parser.renalware_patient?).to be_truthy
          params = parser.parse

          expect(params[:observation_requests]).to be_a(Array)
        end
      end
    end
  end
end
