describe "Heidi linked accounts" do
  around do |example|
    original = Renalware.config.heidi_enabled
    example.run
  ensure
    Renalware.config.heidi_enabled = original
  end

  let(:patient) { create(:patient, :minimal, by: @current_user) }

  describe "GET /patients/:patient_id/heidi_linked_account" do
    it "returns the current user's Heidi linked-account status as JSON" do
      client = instance_double(Renalware::Heidi::Client)
      allow(Renalware::Heidi::Client).to receive(:new).and_return(client)
      allow(client).to receive(:linked_account_access).with(@current_user).and_return(
        Renalware::Heidi::Client::Result.new(
          success: true,
          status: 200,
          body: {
            "is_linked" => true,
            "heidi_user_id" => "heidi-user-1",
            "email" => "clinician@example.test"
          }
        )
      )

      get patient_heidi_linked_account_path(patient), headers: { "Accept" => "application/json" }

      expect(response).to be_successful
      expect(response.parsed_body).to eq("is_linked" => true)
    end

    it "returns a bad gateway response when Heidi status cannot be checked" do
      client = instance_double(Renalware::Heidi::Client)
      allow(Renalware::Heidi::Client).to receive(:new).and_return(client)
      allow(client).to receive(:linked_account_access).with(@current_user).and_return(
        Renalware::Heidi::Client::Result.new(
          success: false,
          status: 502,
          body: {},
          error: "Heidi unavailable"
        )
      )

      get patient_heidi_linked_account_path(patient), headers: { "Accept" => "application/json" }

      expect(response).to have_http_status(:bad_gateway)
      expect(response.parsed_body).to eq(
        "is_linked" => false,
        "error" => "Heidi unavailable"
      )
    end

    it "returns not found and does not call Heidi when Heidi is disabled" do
      Renalware.config.heidi_enabled = false
      allow(Renalware::Heidi::Client).to receive(:new)

      get patient_heidi_linked_account_path(patient), headers: { "Accept" => "application/json" }

      expect(response).to have_http_status(:not_found)
      expect(Renalware::Heidi::Client).not_to have_received(:new)
    end
  end

  describe "POST /patients/:patient_id/heidi_linked_account" do
    it "redirects to Heidi's browser account-linking flow" do
      stub_link_account_url(
        "https://registrar.scribe.heidihealth.com/integration/widget/auth?t=jwt-token"
      )

      post patient_heidi_linked_account_path(patient)

      expect(response).to redirect_to(
        "https://registrar.scribe.heidihealth.com/integration/widget/auth?t=jwt-token"
      )
    end

    it "redirects to the configured Heidi browser account-linking flow" do
      allow(Renalware.config).to receive(:heidi_link_account_url)
        .and_return("https://heidi.example.test/custom/auth")
      stub_link_account_url("https://heidi.example.test/custom/auth?t=jwt-token")

      post patient_heidi_linked_account_path(patient)

      expect(response).to redirect_to("https://heidi.example.test/custom/auth?t=jwt-token")
    end

    it "redirects with an alert when Heidi cannot build the link URL" do
      client = instance_double(Renalware::Heidi::Client)
      allow(Renalware::Heidi::Client).to receive(:new).and_return(client)
      allow(client).to receive(:link_account_url_for).with(@current_user).and_return(
        Renalware::Heidi::Client::Result.new(
          success: false,
          status: 400,
          body: {},
          error: "bad payload"
        )
      )

      post patient_heidi_linked_account_path(patient)

      expect(response).to redirect_to(patient_lab_path(patient))
      expect(flash[:alert]).to eq("Heidi account linking failed: bad payload")
    end

    it "does not redirect to an unexpected Heidi setup URL" do
      stub_link_account_url("https://example.com/integration/widget/auth?t=jwt-token")

      post patient_heidi_linked_account_path(patient)

      expect(response).to redirect_to(patient_lab_path(patient))
      expect(flash[:alert]).to eq(
        "Heidi account linking failed: Heidi account linking returned an invalid setup URL"
      )
    end

    it "returns not found and does not call Heidi when Heidi is disabled" do
      Renalware.config.heidi_enabled = false
      allow(Renalware::Heidi::Client).to receive(:new)

      post patient_heidi_linked_account_path(patient)

      expect(response).to have_http_status(:not_found)
      expect(Renalware::Heidi::Client).not_to have_received(:new)
    end
  end

  describe "GET /patients/:patient_id/heidi_linked_account/new" do
    it "redirects to Heidi's browser account-linking flow" do
      stub_link_account_url(
        "https://registrar.scribe.heidihealth.com/integration/widget/auth?t=jwt-token"
      )

      get new_patient_heidi_linked_account_path(patient)

      expect(response).to redirect_to(
        "https://registrar.scribe.heidihealth.com/integration/widget/auth?t=jwt-token"
      )
    end
  end

  def stub_link_account_url(url)
    client = instance_double(Renalware::Heidi::Client)
    allow(Renalware::Heidi::Client).to receive(:new).and_return(client)
    allow(client).to receive(:link_account_url_for).with(@current_user).and_return(
      Renalware::Heidi::Client::Result.new(
        success: true,
        status: nil,
        body: { "url" => url }
      )
    )
  end
end
