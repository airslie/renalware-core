# frozen_string_literal: true

require "httparty"

# rubocop:disable Metrics/AbcSize
module Renalware
  module Letters::Delivery::TransferOfCare
    # Builds a hash of HTTP headers for MESHAPI requests.
    #
    #  from_mailbox: a string identifying the sending MESH mailbox
    #  to_mailbox:   a string identifying the recipient MESH mailbox
    #  auth_header:  a string, usually omitted so it falls back to AuthHeader.new.call
    #                but useful in tests.
    #
    class API::RequestHeaders
      pattr_initialize [
        :from_mailbox,
        :to_mailbox,
        :subject,
        :auth_header,
        :content_type,
        :local_id
      ]

      # rubocop:disable Metrics/MethodLength
      def to_h
        hash = {
          "Authorization" => auth_header || API::AuthHeader.new.call,
          "Mex-ClientVersion" => "ApiDocs==0.0.1",
          "Mex-FileName" => "None",
          "Mex-MessageType" => "DATA",
          "Mex-OSArchitecture" => "x86_64",
          "Mex-OSName" => "Linux",
          "Mex-OSVersion" => "",
          "Mex-WorkflowID" => Renalware.config.mesh_transfer_of_care_workflow_id
        }
        hash["Mex-From"] = from_mailbox if from_mailbox.present?
        hash["Mex-To"] = to_mailbox.to_s if to_mailbox.present?
        hash["Mex-Subject"] = subject.to_s if subject.present?
        hash["Content-Type"] = content_type.to_s if content_type.present?
        hash["Mex-LocalID"] = local_id.to_s if local_id.present?
        hash
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
# rubocop:enable Metrics/AbcSize
