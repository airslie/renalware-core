module Renalware::Letters::Transports
  module Mesh
    describe DownloadMessageJob do
      include FaradayHelper
      include LettersSpecHelper
      include MeshSpecHelper

      let(:transmission) { Mesh::Transmission.create!(letter: letter) }
      let(:user) { create(:user) }
      let(:letter) do
        create_mesh_letter(
          patient: create_mesh_patient(user: user),
          user: user
        )
      end
      let(:send_operation) {
        Mesh::Operation.create!(transmission: transmission, action: :send_message)
      }

      it "downloads a FHIR XML document via the api" do
        message_id = "123"
        send_operation.reload
        xml = <<-XML
          <Bundle> <!-- Simplified! -->
            <entry>
              <resource>
                <MessageHeader>
                  <response>
                    <identifier value="#{send_operation.uuid}"/>
                  </response>
                </MessageHeader>
              </resource>
            </entry>
          </Bundle>
        XML

        response = mock_faraday_response(
          body: xml,
          headers: { "mex-localid" => send_operation.uuid }
        )

        allow(API::Client).to receive_messages(
          download_message: response,
          acknowledge_message: response
        )

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

      context "when a REPORT message is downloaded (no body, only headers), indicating an " \
              "async error eg undeliverable after 5 days" do
        it "stores the error info in the operation" do
          message_id = "123"
          response = mock_faraday_response(
            headers: {
              "Content-Type" => "application/json",
              "Mex-LocalID" => send_operation.reload.uuid,
              "Mex-MessageType" => "REPORT",
              "Mex-StatusSuccess" => "ERROR",
              "Mex-StatusCode" => "14",
              "Mex-StatusDescription" => "Undelivered message",
              "LinkedMsgID" => message_id
            }
          )

          allow(API::Client).to receive_messages(
            download_message: response,
            acknowledge_message: response
          )

          expect {
            described_class.new.perform(message_id)
          }.to change(Operation, :count).by(2) # download_message, acknowledge_message

          operations = Operation.order(created_at: :asc)
          expect(operations.map(&:action))
            .to eq(%w(send_message download_message acknowledge_message))

          expect(operations[0].transmission_id).to eq(transmission.id)
          expect(operations[1].transmission_id).to eq(transmission.id)
          expect(operations[2].transmission_id).to eq(transmission.id)

          expect(operations[2]).to have_attributes(
            parent_id: send_operation.id,
            transmission_id: transmission.id,
            mesh_error: true,
            mesh_response_error_event: nil,
            mesh_response_error_code: "14",
            mesh_response_error_description: "Undelivered message"
          )
        end
      end
    end
  end
end
