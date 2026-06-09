describe Renalware::Heidi::OutputsClient do
  subject(:outputs_client) do
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

  before do
    allow(client).to receive(:jwt_for).with(user).and_return(
      Renalware::Heidi::Client::Result.new(
        success: true,
        status: 200,
        body: { "token" => "jwt-token" }
      )
    )
  end

  describe "#create_document" do
    it "generates a document for a Heidi session" do
      stub_create_document

      result = outputs_client.create_document(user, "session-1", template_id: "template-1")

      expect(result).to be_success
      expect(result.body).to include("id" => "document-1", "content" => "Clinic letter body")
      stubs.verify_stubbed_calls
    end
  end

  describe "#generate_custom_template_response" do
    it "generates a structured response for a Heidi session" do
      template = { template: "Extract data", questions: [] }
      stub_generate_custom_template_response

      result = outputs_client.generate_custom_template_response(user, "session-1", template)

      expect(result).to be_success
      expect(result.body).to eq("questionAnswers" => [])
      stubs.verify_stubbed_calls
    end
  end

  describe "#clinical_codes" do
    it "fetches generated clinical codes for a Heidi session" do
      stub_clinical_codes

      result = outputs_client.clinical_codes(user, "session-1")

      expect(result).to be_success
      expect(result.body).to eq(
        "codes" => [{ "code" => "73211009", "code_set" => "SNOMED-CT" }]
      )
      stubs.verify_stubbed_calls
    end
  end

  def stub_clinical_codes
    stubs.get("sessions/session-1/clinical-codes") do |env|
      expect_common_headers(env)

      [
        200,
        { "Content-Type" => "application/json" },
        { codes: [{ code: "73211009", code_set: "SNOMED-CT" }] }.to_json
      ]
    end
  end

  def stub_create_document
    stubs.post("sessions/session-1/documents") do |env|
      expect_common_headers(env)
      expect(JSON.parse(env.body)).to eq(document_payload)

      [
        200,
        { "Content-Type" => "application/json" },
        { id: "document-1", content: "Clinic letter body" }.to_json
      ]
    end
  end

  def document_payload
    {
      "document_tab_type" => "DOCUMENT",
      "generation_method" => "TEMPLATE",
      "template_id" => "template-1",
      "voice_style" => "GOLDILOCKS",
      "brain" => "LEFT",
      "content_type" => "MARKDOWN"
    }
  end

  def stub_generate_custom_template_response
    stubs.post("sessions/session-1/client-customised-template/response") do |env|
      expect_common_headers(env)
      expect(JSON.parse(env.body)).to eq("template" => "Extract data", "questions" => [])

      [
        200,
        { "Content-Type" => "application/json" },
        { questionAnswers: [] }.to_json
      ]
    end
  end

  def expect_common_headers(env)
    expect(env.request_headers["Authorization"]).to eq("Bearer jwt-token")
    expect(env.request_headers["Heidi-Api-Key"]).to eq("test-api-key")
  end
end
