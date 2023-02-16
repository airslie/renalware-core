# frozen_string_literal: true

require "rails_helper"
require_relative "../support/message_spec_helper"

module Renalware::Letters::Delivery::TransferOfCare
  describe Jobs::DownloadMessageJob do
    include FaradayHelper
    include LettersSpecHelper
    include MessageSpecHelper

    let(:transmission) { Transmission.create!(letter: letter) }
    let(:user) { create(:user) }
    let(:letter) do
      create_toc_letter(
        patient: create_toc_patient(user: user),
        user: user
      )
    end
    let(:send_operation) {
      Operation.create!(transmission: transmission, action: :send_message)
    }

    it "downloads a FHIR XML document via the api" do
      message_id = "123"
      response = mock_faraday_response(headers: { "mex-localid" => send_operation.reload.uuid })

      allow(API::Client).to receive_messages(download_message: response,
                                             acknowledge_message: response)

      described_class.new.perform(message_id)

      expect(API::Client).to have_received(:download_message).with(message_id)
      expect(API::Client).to have_received(:acknowledge_message).with(message_id)
    end

    it "does not call acknowledge_message if an error is raised during download_message" do
      message_id = "123"
      response = mock_faraday_response(headers: { "mex-localid" => send_operation.reload.uuid })
      allow(API::Client).to receive(:download_message).and_raise(ArgumentError)
      allow(API::Client).to receive(:acknowledge_message).and_return(response)

      expect {
        described_class.new.perform(message_id)
      }.to raise_error ArgumentError

      expect(API::Client).to have_received(:download_message).with(message_id)
      expect(API::Client).not_to have_received(:acknowledge_message).with(message_id)
    end
  end
end
