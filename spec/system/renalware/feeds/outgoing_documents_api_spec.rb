describe "Outgoing Documents API" do
  let(:api_user) do
    create(
      :user,
      username: "xyz",
      authentication_token: "wWsSmmHywhYMWPM6e9ib"
    )
  end

  def bearer_headers(token)
    { "Authorization" => "Bearer #{token}" }
  end

  describe "authorisation" do
    context "when no credentials supplied" do
      it "redirects to the login page" do
        get feeds_queued_outgoing_documents_path

        expect(response).to be_unauthorized
      end
    end

    context "when invalid credentials supplied" do
      it "redirects to login page when provided username does not exist" do
        get feeds_queued_outgoing_documents_path(
          username: "nothing",
          token: "doing"
        )

        expect(response).to be_unauthorized
      end

      it "returns unathorised when provided token in valid does not exist" do
        get feeds_queued_outgoing_documents_path(
          username: api_user.username,
          token: "bla"
        )

        expect(response).to be_unauthorized
      end
    end

    context "when valid credentials supplied" do
      it "continues to accept legacy query credentials" do
        get feeds_queued_outgoing_documents_path(
          username: api_user.username,
          token: api_user.authentication_token
        )

        expect(response).to be_successful
      end

      it "can disable legacy query credentials after deployment migration" do
        allow(Renalware.config)
          .to receive(:legacy_api_query_authentication_enabled)
          .and_return(false)

        get feeds_queued_outgoing_documents_path(
          username: api_user.username,
          token: api_user.authentication_token
        )

        expect(response).to be_unauthorized
      end

      it "accepts a bearer credential with the required scope" do
        issued = Renalware::API::Credential.issue!(
          user: api_user,
          name: "Mirth read",
          scopes: [Renalware::API::Credential::OUTGOING_DOCUMENTS_READ]
        )

        get feeds_queued_outgoing_documents_path, headers: bearer_headers(issued.token)

        expect(response).to be_successful
      end

      it "rejects a bearer credential without the required scope" do
        issued = Renalware::API::Credential.issue!(
          user: api_user,
          name: "Mirth write only",
          scopes: [Renalware::API::Credential::OUTGOING_DOCUMENTS_WRITE]
        )

        get feeds_queued_outgoing_documents_path, headers: bearer_headers(issued.token)

        expect(response).to be_unauthorized
      end

      it "rejects a disabled bearer credential" do
        issued = Renalware::API::Credential.issue!(
          user: api_user,
          name: "Disabled Mirth",
          scopes: [Renalware::API::Credential::OUTGOING_DOCUMENTS_READ]
        )
        issued.credential.update!(enabled: false)

        get feeds_queued_outgoing_documents_path, headers: bearer_headers(issued.token)

        expect(response).to be_unauthorized
      end
    end
  end

  describe "index.json" do
    it "responds successfully with a paginated list of queued documents" do
      user = create(:user)
      event = create(:swab, by: user)
      queued_ev1 = Renalware::Feeds::OutgoingDocument.create!(
        renderable: event,
        by: user,
        created_at: 1.day.ago
      )
      queued_ev2 = Renalware::Feeds::OutgoingDocument.create!(
        renderable: event,
        by: user,
        created_at: 10.days.ago
      )

      get feeds_queued_outgoing_documents_path(
        username: api_user.username,
        token: api_user.authentication_token
      )

      expect(response.media_type).to eq("application/json")
      docs = JSON.parse(response.body).with_indifferent_access
      expect(docs).to eq(
        {
          documents: [
            {
              id: queued_ev2.id,
              state: queued_ev2.state,
              url: feeds_queued_outgoing_document_url(
                queued_ev2,
                protocol: :http,
                host: "www.example.com",
                port: nil
              )
            },
            {
              id: queued_ev1.id,
              state: queued_ev1.state,
              url: feeds_queued_outgoing_document_url(
                queued_ev1,
                protocol: :http,
                host: "www.example.com",
                port: nil
              )
            }
          ]
        }.with_indifferent_access
      )
    end

    describe "show.json" do
      it "responds successfully with json containing an HL7 doc" do
        user = create(:user)
        event = create(:swab, by: user)
        Renalware.config.ukrdc_site_code = "RJZ"
        create(:hospital_centre, code: "RJZ")

        queued_doc = Renalware::Feeds::OutgoingDocument.create!(
          renderable: event,
          by: user,
          created_at: 1.day.ago,
          state: :queued
        )

        get feeds_queued_outgoing_document_path(
          id: queued_doc.id,
          username: api_user.username,
          token: api_user.authentication_token
        )

        expect(response.media_type).to eq("application/json")
        doc = JSON.parse(response.body).with_indifferent_access

        expect(doc[:id]).to eq(queued_doc.id)
        expect(doc[:state]).to eq("queued")
        # expect(doc[:body]).to eq("SOME HL7")
      end
    end

    describe "update.json" do
      let(:user) { create(:user) }
      let(:event) { create(:swab, by: user) }
      let(:queued_doc) do
        Renalware::Feeds::OutgoingDocument.create!(
          renderable: event,
          by: user,
          created_at: 1.day.ago,
          state: :queued
        )
      end

      def path_for_queued_doc(queued_doc)
        feeds_queued_outgoing_document_path(
          id: queued_doc.id,
          username: api_user.username,
          token: api_user.authentication_token
        )
      end

      it "updates the status to processed when no result is supplied" do
        patch path_for_queued_doc(queued_doc)

        expect(response.media_type).to eq("application/json")
        doc = JSON.parse(response.body).with_indifferent_access

        expect(doc[:result]).to eq("OK")
        expect(doc[:state]).to eq("processed")
        expect(queued_doc.reload.state).to eq("processed")
      end

      it "accepts a bearer credential with the write scope" do
        issued = Renalware::API::Credential.issue!(
          user: api_user,
          name: "Mirth write",
          scopes: [Renalware::API::Credential::OUTGOING_DOCUMENTS_WRITE]
        )

        patch(
          feeds_queued_outgoing_document_path(queued_doc),
          headers: bearer_headers(issued.token)
        )

        expect(response).to be_successful
        expect(queued_doc.reload).to be_processed
      end

      it "rejects a bearer credential with only the read scope" do
        issued = Renalware::API::Credential.issue!(
          user: api_user,
          name: "Mirth read only",
          scopes: [Renalware::API::Credential::OUTGOING_DOCUMENTS_READ]
        )

        patch(
          feeds_queued_outgoing_document_path(queued_doc),
          headers: bearer_headers(issued.token)
        )

        expect(response).to be_unauthorized
        expect(queued_doc.reload).to be_queued
      end

      it "updates the status to processed when Mirth reports a successful send" do
        patch path_for_queued_doc(queued_doc), params: { result: "sent" }

        expect(response.media_type).to eq("application/json")
        doc = JSON.parse(response.body).with_indifferent_access

        expect(doc[:result]).to eq("OK")
        expect(doc[:state]).to eq("processed")
        expect(queued_doc.reload.state).to eq("processed")
      end

      it "updates the status to errored when Mirth reports a failed send" do
        freeze_time do
          patch(
            path_for_queued_doc(queued_doc),
            params: {
              result: "failed",
              error_code: "TIE_TIMEOUT",
              error: "Timed out waiting for TIE response",
              comments: "Delivery outcome is unknown"
            }
          )
        end

        expect(response.media_type).to eq("application/json")
        doc = JSON.parse(response.body).with_indifferent_access
        queued_doc.reload

        expect(doc[:result]).to eq("OK")
        expect(doc[:state]).to eq("errored")
        expect(queued_doc).to have_attributes(
          state: "errored",
          error_code: "TIE_TIMEOUT",
          error: "Timed out waiting for TIE response",
          comments: "Delivery outcome is unknown"
        )
        expect(queued_doc.errored_at).to be_within(1.second).of(Time.zone.now)
      end

      it "returns an error when Mirth reports an invalid result" do
        patch path_for_queued_doc(queued_doc), params: { result: "unknown" }

        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)).to eq("error" => "Invalid result")
        expect(queued_doc.reload.state).to eq("queued")
      end
    end
  end
end
