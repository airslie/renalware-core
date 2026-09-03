describe Renalware::Heidi::Client do
  subject(:client) { described_class.new(connection:, api_key:) }

  let(:api_key) { "test-api-key" }
  let(:connection) do
    Faraday.new do |faraday|
      faraday.request :json
      faraday.response :json
      faraday.adapter(:test, stubs)
    end
  end
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:user) do
    build_stubbed(
      :user,
      email: "dr@example.com",
      uuid: "99f3fb36-dcbc-4c89-9138-c4ed04476a18"
    )
  end
  let(:patient) do
    build_stubbed(
      :patient,
      given_name: "John",
      family_name: "Smith",
      born_on: Date.new(1980, 5, 15),
      sex: "M",
      secure_id: "a4556f64-0efd-4d91-8ce4-5390ac345c76"
    )
  end

  describe "#jwt_for" do
    it "requests a JWT using the user's email and uuid" do
      stub_jwt_with_expectations

      result = client.jwt_for(user)

      expect(result).to be_success
      expect(result.body).to eq("token" => "jwt-token")
      stubs.verify_stubbed_calls
    end

    it "fails without an API key" do
      result = described_class.new(connection:, api_key: "").jwt_for(user)

      expect(result).to be_failed
      expect(result.error).to eq("HEIDI_API_KEY is not configured")
    end
  end

  describe "#linked_account_access" do
    it "uses the generated JWT to check linked account status" do
      stub_jwt
      stub_linked_account_access

      result = client.linked_account_access(user)

      expect(result).to be_success
      expect(result.body).to include(
        "is_linked" => true,
        "account" => { "ehr_email" => "dr@example.com" }
      )
      stubs.verify_stubbed_calls
    end
  end

  describe "#link_account_url_for" do
    it "builds the Heidi browser linking URL from the generated JWT" do
      stub_jwt
      allow(Renalware.config).to receive_messages(
        heidi_link_account_url: "https://registrar.scribe.heidihealth.com/integration/widget/auth",
        heidi_region: "AU"
      )

      result = client.link_account_url_for(user)

      expect(result).to be_success
      expect(result.body["url"]).to eq(
        "https://registrar.scribe.heidihealth.com/integration/widget/auth?" \
        "reset=true&region=AU&t=jwt-token&productName=Renalware"
      )
      stubs.verify_stubbed_calls
    end

    it "uses the Heidi browser linking path when configured with only the scribe host" do
      stub_jwt
      allow(Renalware.config).to receive_messages(
        heidi_link_account_url: "https://registrar.scribe.heidihealth.com/",
        heidi_region: "AU"
      )

      result = client.link_account_url_for(user)

      expect(result.body["url"]).to eq(
        "https://registrar.scribe.heidihealth.com/integration/widget/auth?" \
        "reset=true&region=AU&t=jwt-token&productName=Renalware"
      )
      stubs.verify_stubbed_calls
    end
  end

  describe "#unlink_account" do
    it "uses the generated JWT to unlink the current user's Heidi account" do
      stub_jwt
      stub_unlink_account

      result = client.unlink_account(user)

      expect(result).to be_success
      stubs.verify_stubbed_calls
    end
  end

  describe ".launch_url_for" do
    it "builds the Heidi scribe session URL" do
      allow(Renalware.config).to receive(:heidi_scribe_session_base_url)
        .and_return("https://registrar.scribe.heidihealth.com/scribe/session/")

      expect(described_class.launch_url_for("123")).to eq(
        "https://registrar.scribe.heidihealth.com/scribe/session/123"
      )
    end
  end

  def stub_jwt
    stubs.get("jwt") do
      [200, { "Content-Type" => "application/json" }, { token: "jwt-token" }.to_json]
    end
  end

  def stub_jwt_with_expectations
    stubs.get("jwt") do |env|
      expect(env.request_headers["Heidi-Api-Key"]).to eq("test-api-key")
      expect(env.params).to include(
        "email" => "dr@example.com",
        "third_party_internal_id" => "99f3fb36-dcbc-4c89-9138-c4ed04476a18"
      )

      [200, { "Content-Type" => "application/json" }, { token: "jwt-token" }.to_json]
    end
  end

  def stub_linked_account_access
    stubs.get("users/linked-account/access") do |env|
      expect(env.request_headers["Authorization"]).to eq("Bearer jwt-token")

      [
        200,
        { "Content-Type" => "application/json" },
        { is_linked: true, account: { ehr_email: "dr@example.com" } }.to_json
      ]
    end
  end

  def stub_unlink_account
    stubs.delete("users/linked-account:unlink") do |env|
      expect(env.request_headers["Authorization"]).to eq("Bearer jwt-token")

      [
        200,
        { "Content-Type" => "application/json" },
        { account: { ehr_email: "dr@example.com" } }.to_json
      ]
    end
  end
end
