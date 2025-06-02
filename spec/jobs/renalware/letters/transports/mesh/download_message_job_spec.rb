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

      def cassette(path) = File.join("letters/transports/mesh/api", path)

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
        it "identifies the corresponding parent send_message operation, and stores its id, " \
           "the id of the transmission, and the error info in the REPORT, in a new download " \
           "operation" do
          message_id = "123"
          send_operation

          # We are going to use a VCR cassette to return the REPORT message waiting in the inbox.
          # However, because we also need to mock the response to the acknowledge_message call,
          # and we can't use VCR for that (can you have two VCR cassettes in one test?),
          # we will mock the response to acknowledge_message here.
          allow(API::Client)
            .to receive(:acknowledge_message)
            .and_return(
              mock_faraday_response(
                body: "",
                headers: { "Content-Type" => "application/json" }
              )
            )

          # Make sure the MESH API base URL is set to the one we use in VCR.
          allow(Renalware.config).to receive_messages(
            mesh_api_base_url: "http://localhost:8700/messageexchange"
          )

          VCR.use_cassette(cassette("download_message/report/undelivered")) do
            expect {
              described_class.new.perform(message_id)
            }.to change(Operation, :count).by(2) # download_message, acknowledge_message
          end

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

        it "removes the msg from the inbox even if there is no parent transmission " \
           "ie this message was perhaps sent to our mailbox accidentally" do
          message_id = "123"
          unrecognised_uuid = SecureRandom.uuid
          response = mock_faraday_response(
            headers: {
              "Content-Type" => "application/json",
              "Mex-LocalID" => unrecognised_uuid,
              "Mex-MessageType" => "REPORT",
              "Mex-StatusSuccess" => "ERROR",
              "Mex-StatusCode" => "14",
              "Mex-StatusDescription" => "Undelivered message",
              "LinkedMsgID" => unrecognised_uuid
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
          expect(operations.map(&:action)).to eq(%w(download_message acknowledge_message))
          expect(operations.map(&:transmission_id).uniq).to eq([nil])
          download_operation = operations[0]
          expect(download_operation).to have_attributes(
            parent_id: nil,
            transmission_id: nil,
            mesh_error: true,
            mesh_response_error_event: nil,
            mesh_response_error_code: "14",
            mesh_response_error_description: "Undelivered message",
            reconciliation_error: true,
            reconciliation_error_description: "No corresponding send_message operation found " \
                                              "for downloaded message #{message_id}"
          )
        end
      end
    end
  end
end
