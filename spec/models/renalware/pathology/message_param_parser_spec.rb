require "rails_helper"

module Renalware::Pathology
  RSpec.describe MessageParamParser do
    describe "#parse" do
      let(:patient) { create(:patient) }
      let(:observation_description) { create(:pathology_observation_description) }
      let(:request_description) { create(:pathology_request_description) }

      let(:message_payload) {
        double(:message_payload,
          patient_identification: double(internal_id: patient.local_patient_id),
          observation_request: double(
            identifier: request_description.code,
            ordering_provider: "::name::",
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
        params = subject.parse(message_payload)

        expect(params).to eq({
          patient_id: patient.id,
          observation_request: {
            description_id: request_description.id,
            requestor_name: "::name::",
            pcs_code: "::pcs code::",
            observed_at: "2009-11-11 18:41:00 +0000",
            observations_attributes: [
              description_id: observation_description.id,
              observed_at: "2009-11-11 20:26:00 +0000",
              result: "::value::",
              comment: "::comment::"
            ]
          }
        })
      end
    end
  end
end
