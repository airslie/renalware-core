describe Renalware::Heidi::SyncSessionJob do
  include ActiveJob::TestHelper

  subject(:job) { described_class.new }

  let(:heidi_session) { create(:heidi_session) }
  let(:sync_session) { instance_double(Renalware::Heidi::SyncSession, call: heidi_session) }

  before do
    ActiveJob::Base.queue_adapter = :test
    clear_enqueued_jobs
    allow(Renalware::Heidi::SyncSession).to receive(:new)
      .with(session: heidi_session)
      .and_return(sync_session)
  end

  it "syncs the Heidi session" do
    job.perform(heidi_session.id, attempts_remaining: 1)

    expect(sync_session).to have_received(:call)
  end

  it "reschedules while the Heidi consult note is not ready" do
    expect {
      job.perform(heidi_session.id, attempts_remaining: 2)
    }.to have_enqueued_job(described_class).with(heidi_session.id, attempts_remaining: 1)
  end

  it "reschedules after a transient poll failure" do
    sync_session = instance_double(Renalware::Heidi::SyncSession, call: heidi_session)
    allow(Renalware::Heidi::SyncSession).to receive(:new)
      .with(session: heidi_session)
      .and_return(sync_session)
    heidi_session.update!(status: :launched, sync_error: "Heidi unavailable")

    expect {
      job.perform(heidi_session.id, attempts_remaining: 2)
    }.to have_enqueued_job(described_class).with(heidi_session.id, attempts_remaining: 1)
  end

  it "marks the session failed when polling attempts are exhausted" do
    heidi_session.update!(status: :launched, sync_error: "Heidi unavailable")

    expect {
      job.perform(heidi_session.id, attempts_remaining: 1)
    }.not_to have_enqueued_job(described_class)

    expect(heidi_session.reload).to be_sync_failed
    expect(heidi_session.sync_error).to eq("Heidi unavailable")
  end

  it "does not reschedule once the Heidi consult note is synced" do
    heidi_session.synced!

    expect {
      job.perform(heidi_session.id, attempts_remaining: 2)
    }.not_to have_enqueued_job(described_class)
  end
end
