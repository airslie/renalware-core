require "rails_helper"

module Renalware::Pathology
  RSpec.describe MessageParamParser do
    describe "#parse" do
      let(:message_payload) {
        double(:message_payload,
          observation_request: double(
            ordering_provider: "::name::",
            placer_order_number: "::pcs code::",
            observation_date_time: "200911111841"
          )
        )
      }

      it "transfers attributes from the message payload to the params" do
        params = subject.parse(message_payload)

        expect(params).to eq({
          observation_request: {
            requestor_name: "::name::",
            pcs_code: "::pcs code::",
            observed_at: "2009-11-11 18:41:00 -0500"
          }
        })
      end
    end
  end
end
