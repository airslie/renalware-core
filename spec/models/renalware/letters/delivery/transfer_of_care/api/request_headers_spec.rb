# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters::Delivery::TransferOfCare
  describe API::RequestHeaders do
    describe "#to_h" do
      subject { described_class.new(auth_header: "my-auth-header").to_h }

      before do
        allow(Renalware.config).to receive(:mesh_transfer_of_care_workflow_id).and_return("ABC")
      end

      it "returns a hash of headers" do
        is_expected.to eq(
          "Authorization" => "my-auth-header",
          "Mex-ClientVersion" => "ApiDocs==0.0.1",
          "Mex-OSArchitecture" => "x86_64",
          "Mex-OSName" => "Linux",
          "Mex-OSVersion" => "",
          "Mex-FileName" => "None",
          "Mex-MessageType" => "DATA",
          "Mex-WorkflowID" => "ABC"
        )
      end

      context "when from_mailbox is supplied" do
        subject { described_class.new(auth_header: "my-auth-header", from_mailbox: "FROM").to_h }

        it { is_expected.to include("Mex-From" => "FROM") }
      end

      context "when to_mailbox is supplied" do
        subject { described_class.new(auth_header: "my-auth-header", to_mailbox: "TO").to_h }

        it { is_expected.to include("Mex-To" => "TO") }
      end

      context "when subject is supplied" do
        subject { described_class.new(auth_header: "my-auth-header", subject: "SUBJECT").to_h }

        it { is_expected.to include("Mex-Subject" => "SUBJECT") }
      end

      context "when local_id is supplied" do
        subject { described_class.new(local_id: "xyz").to_h }

        it { is_expected.to include("Mex-LocalID" => "xyz") }
      end
    end
  end
end
