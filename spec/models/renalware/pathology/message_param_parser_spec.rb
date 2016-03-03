require "rails_helper"

module Renalware::Pathology
  RSpec.describe MessageParamParser do
    describe "#parse" do
      let(:message_payload) {
        double(:message_payload,
          observation_request: double(
            ordering_provider: "::name::",
            placer_order_number: "::pcs code::"
          )
        )
      }

      it "transfers attributes from the message payload to the params" do
        params = subject.parse(message_payload)

        expect(params).to eq({
          observation_request: {
            requestor_name: "::name::",
            pcs_code: "::pcs code::"
          }
        })
      end
    end
  end
end
