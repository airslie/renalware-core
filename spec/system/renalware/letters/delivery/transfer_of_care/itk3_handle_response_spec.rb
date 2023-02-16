# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters::Delivery::TransferOfCare
  describe "Handling ITK3 responses" do
    include LettersSpecHelper
    include FaradayHelper

    let(:user) { create(:user) }
    let(:practice) { create(:practice) }

    def cassette(path)
      File.join("letters/delivery/transfer_of_care/api", path)
    end

    def create_patient(given_name: "John")
      create(
        :letter_patient,
        given_name: given_name, # trigger value
        practice: practice,
        primary_care_physician: create(:letter_primary_care_physician, practices: [practice]),
        by: user
      )
    end

    def stub_acknowledge_message
      acknowledge_message_response = mock_faraday_response
      allow(acknowledge_message_response).to receive_messages(
        body: {},
        headers: { "Content-Type" => "application/json" }
      )
      allow(API::Client)
        .to receive(:acknowledge_message)
        .and_return(acknowledge_message_response)
    end

    def stub_download_message(scenario)
      download_message_response = mock_faraday_response(body: scenario[:xml], content_type: :xml)
      allow(API::Client)
        .to receive(:download_message)
        .and_return(download_message_response)
    end

    Dir[
      Renalware::Engine.root.join(
        "spec/fixtures/files/letters/delivery/tansfer_of_care/api/response_scenarios/*.yml"
      )
    ].each do |file|
      basename = File.basename(file, ".yml")
      scenario = YAML.load_file(file).deep_symbolize_keys[:scenario]

      # TODO: this is testing at the wrong level :-/
      it scenario[:test_case_name] do
        patient = create_patient(given_name: basename) # trigger value
        letter = create_letter(
          state: :pending_review,
          to: :primary_care_physician,
          patient: patient,
          author: user,
          by: user
        )
        Renalware::Letters::ApproveLetter.new(letter).call(by: user)
        letter = Renalware::Letters::Letter.find(letter.id) # as active type has changed
        mesh_msg_id = "d3e5dc69-fc58-4014-8326-7c4184dc54b9"
        message = Transmission.create!(
          letter: letter
        )
        stub_download_message(scenario)
        stub_acknowledge_message

        Jobs::DownloadMessageJob.perform_now(mesh_msg_id)

        expect(API::Client).to have_received(:download_message)
        expect(API::Client).to have_received(:acknowledge_message)

        pending "FIXME!"

        expect(message.reload).to have_attributes(**scenario[:expectation])
      end
    end
  end
end
