describe Renalware::Heidi::SessionsClient do
  subject(:sessions_client) do
    described_class.new(client:, connection:, api_key: "test-api-key")
  end

  let(:client) { instance_double(Renalware::Heidi::Client) }
  let(:connection) do
    Faraday.new do |faraday|
      faraday.request :json
      faraday.response :json
      faraday.adapter(:test, stubs)
    end
  end
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:user) { build_stubbed(:user) }
  let(:patient) { build_stubbed(:patient) }

  before do
    allow(client).to receive(:jwt_for).with(user).and_return(
      Renalware::Heidi::Client::Result.new(
        success: true,
        status: 200,
        body: { "token" => "jwt-token" }
      )
    )
  end

  describe "#create" do
    it "creates a session using the generated JWT" do
      stub_create_session

      result = sessions_client.create(user)

      expect(result).to be_success
      expect(result.body).to eq("session_id" => "1234567890")
      stubs.verify_stubbed_calls
    end
  end

  describe "#create_for_patient" do
    it "creates a session, links a patient profile, patches context, and returns launch data" do
      stub_create_session
      stub_patient_profiles_client
      stub_context_builder
      stub_update_session

      result = sessions_client.create_for_patient(user, patient)

      expect(result).to be_success
      expect(result.body).to include(
        "session_id" => "1234567890",
        "patient_profile_id" => "profile-1"
      )
      stubs.verify_stubbed_calls
    end
  end

  describe "#update" do
    it "patches Heidi session context" do
      stub_update_session

      result = sessions_client.update(
        user,
        "1234567890",
        clinician_notes: ["Renalware patient problems:", "- Diabetes mellitus"]
      )

      expect(result).to be_success
      stubs.verify_stubbed_calls
    end
  end

  describe "#get" do
    it "fetches Heidi session details" do
      stub_session_details

      result = sessions_client.get(user, "session-1")

      expect(result).to be_success
      expect(result.body).to eq("session" => { "session_id" => "session-1" })
      stubs.verify_stubbed_calls
    end
  end

  def stub_create_session
    stubs.post("sessions") do |env|
      expect(env.request_headers["Authorization"]).to eq("Bearer jwt-token")
      expect(env.request_headers["Heidi-Api-Key"]).to eq("test-api-key")
      expect(JSON.parse(env.body)).to eq({})

      [200, { "Content-Type" => "application/json" }, { session_id: "1234567890" }.to_json]
    end
  end

  def stub_patient_profiles_client
    patient_profiles = instance_double(Renalware::Heidi::PatientProfilesClient)
    allow(Renalware::Heidi::PatientProfilesClient).to receive(:new).and_return(patient_profiles)
    stub_find_or_create_patient_profile(patient_profiles)
    stub_link_patient_profile_to_session(patient_profiles)
  end

  def stub_find_or_create_patient_profile(patient_profiles)
    allow(patient_profiles).to receive(:find_or_create)
      .with(user, patient)
      .and_return(heidi_result(body: { "id" => "profile-1" }))
  end

  def stub_link_patient_profile_to_session(patient_profiles)
    allow(patient_profiles).to receive(:link_session)
      .with(
        user,
        patient_profile_id: "profile-1",
        session_id: "1234567890"
      )
      .and_return(heidi_result(body: { "data" => [{ "session_id" => "1234567890" }] }))
  end

  def heidi_result(body:)
    Renalware::Heidi::Client::Result.new(success: true, status: 200, body:)
  end

  def stub_context_builder
    context_builder = instance_double(
      Renalware::Heidi::SessionContextBuilder,
      call: { clinician_notes: ["Renalware patient problems:", "- Diabetes mellitus"] }
    )
    allow(Renalware::Heidi::SessionContextBuilder).to receive(:new)
      .with(patient)
      .and_return(context_builder)
  end

  def stub_update_session
    stubs.patch("sessions/1234567890") do |env|
      expect(env.request_headers["Authorization"]).to eq("Bearer jwt-token")
      expect(env.request_headers["Heidi-Api-Key"]).to eq("test-api-key")
      expect(JSON.parse(env.body)).to eq(
        "clinician_notes" => [
          "Renalware patient problems:",
          "- Diabetes mellitus"
        ]
      )

      [200, { "Content-Type" => "application/json" }, { session_id: "1234567890" }.to_json]
    end
  end

  def stub_session_details
    stubs.get("sessions/session-1") do |env|
      expect(env.request_headers["Authorization"]).to eq("Bearer jwt-token")
      expect(env.request_headers["Heidi-Api-Key"]).to eq("test-api-key")

      [
        200,
        { "Content-Type" => "application/json" },
        { session: { session_id: "session-1" } }.to_json
      ]
    end
  end
end
