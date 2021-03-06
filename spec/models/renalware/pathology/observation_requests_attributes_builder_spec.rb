# frozen_string_literal: true

require "rails_helper"

module Renalware::Pathology
  describe ObservationRequestsAttributesBuilder do
    describe "#parse" do
      let(:patient) { create(:patient) }
      let(:observation_description) { create(:pathology_observation_description) }
      let(:request_description) { create(:pathology_request_description) }

      # Message payload simulates the HL7 message mapped into a hash (and already
      # archived in feed_messages).
      let(:hl7_message) {
        double(
          :hl7_message,
          patient_identification: double(internal_id: patient.local_patient_id),
          observation_requests: [
            double(
              identifier: request_description.code,
              name: request_description.code,
              ordering_provider_name: "::name::",
              placer_order_number: "::pcs code::",
              date_time: "200911111841",
              observations: [
                double(
                  identifier: observation_description.code,
                  name: observation_description.name,
                  date_time: "200911112026",
                  value: "::value::",
                  comment: "::comment::",
                  cancelled: nil,
                  units: "mg"
                )
              ]
            )
          ]
        )
      }

      it "transfers attributes from the message payload to the params" do
        parser = described_class.new(hl7_message)

        expect(parser.renalware_patient?).to eq(true)
        params = parser.parse

        expect(params).to eq(
          [
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
                  comment: "::comment::",
                  cancelled: nil
                ]
              }
            }
          ]
        )
      end

      context "when the patient is not found" do
        it "logs a warning fails silently. This is an acceptable outcome "\
           "because most pathology messages will be for non-renal patients, and we ignore them" do
          non_existent_patient = "123123123"
          hl7_message = double(
            :hl7_message,
            patient_identification: double(internal_id: non_existent_patient),
            observation_request: double(
              identifier: request_description.code,
              name: request_description.name,
              ordering_provider_name: "::name::",
              placer_order_number: "::pcs code::",
              date_time: "200911111841",
              observations: [
                double(
                  identifier: observation_description.code,
                  date_time: "200911112026",
                  value: "::value::",
                  comment: "::comment::",
                  cancelled: nil,
                  units: ""
                )
              ]
            )
          )
          logger = instance_double("Rails.logger").as_null_object
          allow(logger).to receive(:debug)

          parser = described_class.new(hl7_message, logger)

          expect(parser).not_to be_renalware_patient
          expect(parser.parse).to be_nil
          expect(logger).to have_received(:debug).once
        end
      end

      context "when the message has > 1 OBR segment" do
        let(:raw_message) do
          <<-RAW.strip_heredoc
            MSH|^~\&|HM|LIVE|SCM||20181212170103||ORU^R01|00002286|P|2.3.1|||AL
            PID|||Z999990^^^PAS Number||XXX^XXX^^^Mr||11110715|M|||ss^ss^^^SE00 600
            PV1||Inpatient|COPK|||||RABRO^Rabbit, Roger||||||||||NHS|ED001332881^^^Visit Number
            ORC|RE|PLACERORDERNO1^PCS|1010101010^LA||CM||||201801251204|||RABRO^Rabbit, Roger
            OBR|1|PLACERORDERNO1^PCS|1010101010^LA|RLU^RENAL/LIVER/UREA^HM||201801251204|201801250541||||||.|201801250541|B^Blood|RABRO^Rabbit, Roger||1010101010||||201801251249||HM|F
            OBX|1|NM|NA^Sodium^HM||136|mmol/L|||||F|||201801251249||BHISVC01^BHI Authchecker
            ORC|RE|PLACERORDERNO2^PCS|100000000^LA||CM||||201801251204|||RABRO^Rabbit, Roger
            OBR|2|PLACERORDERNO2^PCS|1010101010^LA|BONE^BONE PROFILE^HM||201801251204|201801250541||||||.|201801250541|B^Blood|RABRO^Rabbit, Roger||1010101010||||201801251700||HM|F
            OBX|1|NM|CCA^Corrected Calc^HM||3.16|mmol/L||H|||F|||201801251700||CBEAA^X Y
          RAW
        end

        it "does not throw `undefined local variable or method `universal_service_id'`" do
          create(:pathology_request_description, code: "RLU")
          create(:pathology_request_description, code: "BONE")
          create(:pathology_observation_description, code: "NA")
          create(:pathology_observation_description, code: "CCA")
          create(:patient, local_patient_id: "Z999990")
          message = Renalware::Feeds::MessageParser.parse(raw_message)

          parser = described_class.new(message)

          expect { parser.parse }.not_to raise_error
        end

        it "creates a params hash with multiple observation_requests" do
          parser = described_class.new(hl7_message)
          expect(parser.renalware_patient?).to eq(true)
          params = parser.parse

          expect(params).to be_a(Array)
        end
      end

      context "when the message has an OBX segment (eg WSUM) with no observation date" do
        let(:raw_message) do
          <<-RAW.strip_heredoc
            MSH|^~\&|BLB|LIVE|SCM||1111111||ORU^R01|1111111|P|2.3.1|||AL
            PID|||V1111111^^^PAS Number||SSS^SS^^^Mr||1111111|M|||s^s^^^x
            PV1||Inpatient|DMU|||||xxx^xx, xxxx||||||||||NHS|V1111111^^^Visit Number
            ORC|RE|0031111111^PCS|18T1111111^LA||CM||||201801221418|||xxx^xx, xxxx
            OBR|1|0031111111^PCS|181111111^LA|GS^UNKNOWN G\T\S^BLB||201801221418|201801221418||||||haematology + 1 extra sample|201801221418|B^Blood|xxx^xx, xxxx||18T000000001||||201801251706||BLB|F
            OBX|1|ST|GRP^Blood Group^BLB||A Rh D POSITIVE||||||F|||201801221711||BBAO^Bill Glover
            OBX|2|ST|WSUM^Ward Unit Summary^BLB||......notes here......||||||F|||||WPBTSV5^BloodTracking
          RAW
        end

        it "excludes those OBX segments and logs a warning" do
          create(:pathology_request_description, code: "GS")
          included_description = create(:pathology_observation_description, code: "GRP")
          create(:pathology_observation_description, code: "WSUM")
          create(:patient, local_patient_id: "V1111111")
          logger = instance_spy("Rails.logger")
          allow(logger).to receive(:warn).once

          message = Renalware::Feeds::MessageParser.parse(raw_message)
          parser = described_class.new(message, logger)
          results = parser.parse

          # Assert that WSUM was excluded
          expect(logger).to have_received(:warn)
          expect(results.length).to eq(1)
          observations_to_create = results[0].dig(:observation_request, :observations_attributes)
          expect(observations_to_create.length).to eq(1)
          expect(
            observations_to_create.pluck(:description_id)
          ).to eq([included_description.id])
        end
      end

      context "when requestor order name not present in the HL7 message" do
        let(:hl7_message) {
          instance_double(
            Renalware::Feeds::HL7Message,
            patient_identification: double(internal_id: patient.local_patient_id),
            observation_requests: [
              double(
                identifier: request_description.code,
                name: request_description.name,
                ordering_provider_name: nil,
                placer_order_number: "::pcs code::",
                date_time: "200911111841",
                observations: []
              )
            ]
          )
        }

        it "uses 'UNKNOWN'" do
          requests = described_class.new(hl7_message).parse
          expect(requests.first[:observation_request][:requestor_name]).to eq("UNKNOWN")
        end
      end

      context "when requested_at not present in the HL7 message" do
        let(:hl7_message) {
          double(
            :hl7_message,
            patient_identification: double(internal_id: patient.local_patient_id),
            observation_requests: [
              double(
                identifier: request_description.code,
                name: request_description.name,
                ordering_provider_name: "aasas",
                placer_order_number: "::pcs code::",
                date_time: nil,
                observations: []
              )
            ]
          )
        }

        it "uses the current data and time" do
          travel_to Time.zone.local(2018, 01, 01, 01, 01, 01) do
            requests = described_class.new(hl7_message).parse
            expect(requests.first[:observation_request][:requested_at])
              .to eq("2018-01-01 01:01:01 +0000")
          end
        end
      end

      context "when the OBR code is no found" do
        let(:hl7_message) {
          double(
            :hl7_message,
            patient_identification: double(internal_id: patient.local_patient_id),
            observation_requests: [
              double(
                identifier: "I_DO_NOT_EXIST_CODE",
                name: "I_DO_NOT_EXIST_NAME",
                ordering_provider_name: "aasas",
                placer_order_number: "::pcs code::",
                date_time: nil,
                observations: []
              )
            ]
          )
        }

        it "creates the OBR code dynamcically" do
          create(:pathology_lab, name: "Lab: Unknown")
          described_class.new(hl7_message).parse

          expect(
            RequestDescription.exists?(
              code: "I_DO_NOT_EXIST_CODE",
              name: "I_DO_NOT_EXIST_NAME"
            )
          ).to eq(true)
        end
      end

      context "when the OBX code is not found" do
        let(:hl7_message) {
          double(
            :hl7_message,
            patient_identification: double(internal_id: patient.local_patient_id),
            observation_requests: [
              double(
                identifier: request_description.code,
                name: request_description.name,
                ordering_provider_name: "aasas",
                placer_order_number: "::pcs code::",
                date_time: nil,
                observations: [
                  double(
                    identifier: "I_DO_NOT_EXIST_CODE",
                    name: "I_DO_NOT_EXIST_NAME",
                    date_time: "200911112026",
                    value: "::value::",
                    comment: "::comment::",
                    cancelled: nil,
                    units: ""
                  )
                ]
              )
            ]
          )
        }

        it "creates the OBX code dynamcically" do
          described_class.new(hl7_message).parse

          expect(
            ObservationDescription.exists?(
              code: "I_DO_NOT_EXIST_CODE",
              name: "I_DO_NOT_EXIST_NAME"
            )
          ).to eq(true)
        end
      end
    end
  end
end
