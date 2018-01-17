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
    end
  end
end
