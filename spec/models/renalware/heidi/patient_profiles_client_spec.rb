describe Renalware::Heidi::PatientProfilesClient do
  subject(:patient_profiles) do
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

  before do
    allow(client).to receive(:jwt_for).with(user).and_return(
      Renalware::Heidi::Client::Result.new(
        success: true,
        status: 200,
        body: { "token" => "jwt-token" }
      )
    )
  end

  describe "#find" do
    it "finds patient profiles by Renalware patient UUID" do
      stub_patient_profiles

      result = patient_profiles.find(
        user,
        ehr_patient_id: "a4556f64-0efd-4d91-8ce4-5390ac345c76"
      )

      expect(result).to be_success
      expect(result.body).to eq("data" => [{ "id" => "profile-1" }])
      stubs.verify_stubbed_calls
    end
  end

  describe "#create" do
    it "creates a patient profile from Renalware demographics" do
      stub_create_patient_profile

      result = patient_profiles.create(user, patient)

      expect(result).to be_success
      expect(result.body).to eq("data" => { "id" => "profile-1" })
      stubs.verify_stubbed_calls
    end
  end

  describe "#find_or_create" do
    it "uses an existing profile when Heidi already has one for the Renalware patient" do
      stub_patient_profiles

      result = patient_profiles.find_or_create(user, patient)

      expect(result).to be_success
      expect(result.body).to eq("id" => "profile-1")
      stubs.verify_stubbed_calls
    end

    it "creates a profile when Heidi does not have one for the Renalware patient" do
      stub_empty_patient_profiles
      stub_create_patient_profile

      result = patient_profiles.find_or_create(user, patient)

      expect(result).to be_success
      expect(result.body).to eq("id" => "profile-1")
      stubs.verify_stubbed_calls
    end
  end

  describe "#link_session" do
    it "links the session to the patient profile" do
      stub_link_session_to_patient_profile

      result = patient_profiles.link_session(
        user,
        patient_profile_id: "profile-1",
        session_id: "1234567890"
      )

      expect(result).to be_success
      stubs.verify_stubbed_calls
    end
  end

  def stub_patient_profiles
    stubs.get("patient-profiles") do |env|
      expect(env.request_headers["Authorization"]).to eq("Bearer jwt-token")
      expect(env.request_headers["Heidi-Api-Key"]).to eq("test-api-key")
      expect(env.params).to include(
        "ehr_patient_id" => "a4556f64-0efd-4d91-8ce4-5390ac345c76"
      )

      [200, { "Content-Type" => "application/json" }, { data: [{ id: "profile-1" }] }.to_json]
    end
  end

  def stub_empty_patient_profiles
    stubs.get("patient-profiles") do
      [200, { "Content-Type" => "application/json" }, { data: [] }.to_json]
    end
  end

  def stub_create_patient_profile
    stubs.post("patient-profiles") do |env|
      expect(env.request_headers["Authorization"]).to eq("Bearer jwt-token")
      expect(env.request_headers["Heidi-Api-Key"]).to eq("test-api-key")
      expect(JSON.parse(env.body)).to eq(expected_patient_profile_payload)

      [200, { "Content-Type" => "application/json" }, { data: { id: "profile-1" } }.to_json]
    end
  end

  def expected_patient_profile_payload
    {
      "first_name" => "John",
      "last_name" => "Smith",
      "birth_date" => "1980-05-15",
      "gender" => "male",
      "ehr_patient_id" => "a4556f64-0efd-4d91-8ce4-5390ac345c76",
      "demographic_string" => "John Smith, M, 1980-05-15"
    }
  end

  def stub_link_session_to_patient_profile
    stubs.post("patient-profiles/profile-1/sessions") do |env|
      expect(env.request_headers["Authorization"]).to eq("Bearer jwt-token")
      expect(env.request_headers["Heidi-Api-Key"]).to eq("test-api-key")
      expect(JSON.parse(env.body)).to eq("session_ids" => ["1234567890"])

      [
        200,
        { "Content-Type" => "application/json" },
        { data: [{ session_id: "1234567890" }] }.to_json
      ]
    end
  end
end
