# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters::Transports::Mesh
  describe API::RequestHeaders do
    describe "#to_h" do
      subject do
        described_class.new(
          auth_header: "my-auth-header",
          to: "TO",
          subject: "SUBJECT",
          operation_uuid: "operation_uuid"
        ).to_h
      end

      before do
        allow(Renalware.config).to receive_messages(
          mesh_organisation_ods_code: "123",
          letters_mesh_workflow: :gp_connect,
          mesh_mailbox_id: "MB1"
        )
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
          "Mex-WorkflowID" => "GPCONNECT_SEND_DOCUMENT",
          "Mex-From" => "MB1", # GPCM-SD-062
          "Mex-To" => "TO",
          "Mex-LocalID" => "123", # GPCM-SD-146
          "X-OperationID" => "operation_uuid",
          "Mex-Subject" => "SUBJECT",
          "Content-Type" => "application/xml"
        )
      end
    end
  end
end
