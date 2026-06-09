describe Renalware::Heidi::GenerateOutputs do
  subject(:generate_outputs) do
    described_class.new(session:, document_template_id:, client:)
  end

  let(:session) { create(:heidi_session) }
  let(:document_template_id) { "document-template-1" }
  let(:client) { instance_double(Renalware::Heidi::OutputsClient) }

  it "stores generated document content and structured output" do
    allow(client).to receive(:create_document)
      .with(session.user, session.heidi_session_id, template_id: "document-template-1")
      .and_return(
        heidi_result({
                       "id" => "document-1",
                       "content_type" => "MARKDOWN",
                       "content" => "Generated letter body"
                     })
      )
    allow(client).to receive(:generate_custom_template_response)
      .with(
        session.user,
        session.heidi_session_id,
        Renalware::Heidi::StructuredOutputTemplate.call
      )
      .and_return(heidi_result({ "questionAnswers" => [{ "questionId" => "new_problems" }] }))
    allow(client).to receive(:clinical_codes)
      .with(session.user, session.heidi_session_id)
      .and_return(
        heidi_result({
                       "codes" => [
                         { "code" => "73211009", "code_set" => "SNOMED-CT" }
                       ]
                     })
      )

    generate_outputs.call

    expect(session.reload).to have_attributes(
      document_template_id: "document-template-1",
      document_content_type: "MARKDOWN",
      document_content: "Generated letter body",
      document_response: include("id" => "document-1"),
      structured_response: include("questionAnswers" => [{ "questionId" => "new_problems" }]),
      clinical_codes_response: include(
        "codes" => [{ "code" => "73211009", "code_set" => "SNOMED-CT" }]
      ),
      outputs_error: nil
    )
    expect(session.outputs_generated_at).to be_present
  end

  context "when no document template ID is supplied" do
    let(:document_template_id) { "" }

    it "generates only structured output" do
      allow(client).to receive(:create_document)
      allow(client).to receive(:generate_custom_template_response)
        .with(
          session.user,
          session.heidi_session_id,
          Renalware::Heidi::StructuredOutputTemplate.call
        )
        .and_return(heidi_result({ "questionAnswers" => [] }))
      allow(client).to receive(:clinical_codes)
        .with(session.user, session.heidi_session_id)
        .and_return(heidi_result({ "codes" => [] }))

      generate_outputs.call

      expect(client).not_to have_received(:create_document)
      expect(session.reload.structured_response).to eq("questionAnswers" => [])
      expect(session.clinical_codes_response).to eq("codes" => [])
      expect(session.document_response).to eq({})
    end
  end

  it "stores the error when Heidi rejects an output request" do
    allow(client).to receive(:create_document)
      .and_return(heidi_result(success: false, error: "Template not found"))

    generate_outputs.call

    expect(session.reload.outputs_error).to eq("Template not found")
    expect(session.outputs_generated_at).to be_present
  end

  def heidi_result(body = {}, success: true, error: nil)
    Renalware::Heidi::Client::Result.new(success:, status: success ? 200 : 400, body:, error:)
  end
end
