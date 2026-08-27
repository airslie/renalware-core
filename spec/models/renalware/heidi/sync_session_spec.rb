describe Renalware::Heidi::SyncSession do
  subject(:sync) { described_class.new(session:, client:) }

  let(:session) { create(:heidi_session) }
  let(:client) { instance_double(Renalware::Heidi::SessionsClient) }

  it "stores a completed consult note" do
    allow(client).to receive(:get).with(session.user, session.heidi_session_id).and_return(
      Renalware::Heidi::Client::Result.new(
        success: true,
        status: 200,
        body: {
          "session" => {
            "consult_note" => {
              "status" => "COMPLETED",
              "result" => "Generated renal clinic note"
            }
          }
        }
      )
    )

    sync.call

    expect(session.reload).to be_synced
    expect(session.consult_note_status).to eq("COMPLETED")
    expect(session.consult_note).to eq("Generated renal clinic note")
    expect(session.last_synced_at).to be_present
    expect(session.sync_error).to be_nil
  end

  it "appends the completed consult note to the associated clinic visit notes" do
    clinic_visit = create(:clinic_visit, notes: "Existing notes")
    session.update!(clinic_visit:)
    allow(client).to receive(:get).with(session.user, session.heidi_session_id).and_return(
      Renalware::Heidi::Client::Result.new(
        success: true,
        status: 200,
        body: {
          "session" => {
            "consult_note" => {
              "status" => "COMPLETED",
              "result" => "Generated renal clinic note"
            }
          }
        }
      )
    )

    sync.call

    expect(clinic_visit.reload.notes).to eq(
      "Existing notes\n\nHeidi consult note:\nGenerated renal clinic note"
    )
  end

  it "does not append the consult note again when the Heidi note was already stored" do
    clinic_visit = create(:clinic_visit, notes: "Existing notes")
    session.update!(clinic_visit:, consult_note: "Previously synced note")
    allow(client).to receive(:get).with(session.user, session.heidi_session_id).and_return(
      Renalware::Heidi::Client::Result.new(
        success: true,
        status: 200,
        body: {
          "session" => {
            "consult_note" => {
              "status" => "COMPLETED",
              "result" => "Previously synced note"
            }
          }
        }
      )
    )

    sync.call

    expect(clinic_visit.reload.notes).to eq("Existing notes")
  end

  it "leaves the session launched when the consult note is not ready" do
    allow(client).to receive(:get).with(session.user, session.heidi_session_id).and_return(
      Renalware::Heidi::Client::Result.new(
        success: true,
        status: 200,
        body: { "session" => { "consult_note" => { "status" => "CREATED" } } }
      )
    )

    sync.call

    expect(session.reload).to be_launched
    expect(session.consult_note_status).to eq("CREATED")
    expect(session.consult_note).to be_nil
    expect(session.last_synced_at).to be_present
  end

  it "marks the session as failed when Heidi rejects the request" do
    allow(client).to receive(:get).with(session.user, session.heidi_session_id).and_return(
      Renalware::Heidi::Client::Result.new(
        success: false,
        status: 403,
        body: {},
        error: "not linked"
      )
    )

    sync.call

    expect(session.reload).to be_sync_failed
    expect(session.sync_error).to eq("not linked")
    expect(session.last_synced_at).to be_present
  end
end
