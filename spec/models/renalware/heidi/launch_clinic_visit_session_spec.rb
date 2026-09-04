describe Renalware::Heidi::LaunchClinicVisitSession do
  include ActiveJob::TestHelper

  subject(:launcher) do
    described_class.new(
      clinic_visit:,
      user:,
      client:,
      sessions_client:,
      patient_profiles_client:
    )
  end

  let(:clinic_visit) { create(:clinic_visit) }
  let(:user) { create(:user) }
  let(:client) { instance_double(Renalware::Heidi::Client) }
  let(:sessions_client) { instance_double(Renalware::Heidi::SessionsClient) }
  let(:patient_profiles_client) { instance_double(Renalware::Heidi::PatientProfilesClient) }

  before do
    ActiveJob::Base.queue_adapter = :test
    clear_enqueued_jobs
  end

  it "creates a Heidi session for the clinic visit and enqueues consult-note polling" do
    allow_linked_account
    allow_heidi_session_created
    allow_patient_profile_linked
    allow_session_context_updated

    expect {
      result = launcher.call

      expect(result).to be_success
      expect(result.session).to have_attributes(
        patient: clinic_visit.patient,
        clinic_visit:,
        user:,
        heidi_session_id: "heidi-session-1",
        heidi_patient_profile_id: "patient-profile-1",
        status: "launched"
      )
    }.to change(Renalware::Heidi::Session, :count).by(1)
      .and have_enqueued_job(Renalware::Heidi::SyncSessionJob)
  end

  it "returns a failure when Heidi does not create a session" do
    allow_linked_account
    allow(sessions_client).to receive(:create).with(user).and_return(
      heidi_result(success: false, error: "not linked")
    )

    result = nil
    expect {
      result = launcher.call
    }.to change(Renalware::Heidi::Session, :count).by(1)

    expect(result).to be_failed
    expect(result.error).to eq("not linked")
    expect(result.session).to be_launch_failed
    expect(result.session.sync_error).to eq("not linked")
    expect(result.session.heidi_session_id).to be_nil
    expect(enqueued_jobs).to be_empty
  end

  it "stores the remote Heidi session ID when a later launch step fails" do
    allow_linked_account
    allow_heidi_session_created
    allow(patient_profiles_client).to receive(:find_or_create)
      .with(user, clinic_visit.patient)
      .and_return(heidi_result(success: false, error: "profile failed"))

    result = nil
    expect {
      result = launcher.call
    }.to change(Renalware::Heidi::Session, :count).by(1)

    expect(result).to be_failed
    expect(result.error).to eq("profile failed")
    expect(result.session).to have_attributes(
      status: "launch_failed",
      heidi_session_id: "heidi-session-1",
      heidi_patient_profile_id: nil,
      sync_error: "profile failed"
    )
    expect(enqueued_jobs).to be_empty
  end

  it "stores the patient profile ID when session linking fails" do
    allow_linked_account
    allow_heidi_session_created
    allow(patient_profiles_client).to receive(:find_or_create)
      .with(user, clinic_visit.patient)
      .and_return(heidi_result(success: true, body: { "id" => "patient-profile-1" }))
    allow(patient_profiles_client).to receive(:link_session)
      .with(
        user,
        patient_profile_id: "patient-profile-1",
        session_id: "heidi-session-1"
      )
      .and_return(heidi_result(success: false, error: "link failed"))

    result = launcher.call

    expect(result).to be_failed
    expect(result.session).to have_attributes(
      status: "launch_failed",
      heidi_session_id: "heidi-session-1",
      heidi_patient_profile_id: "patient-profile-1",
      sync_error: "link failed"
    )
    expect(enqueued_jobs).to be_empty
  end

  it "returns an account-link failure when the user is not linked to Heidi" do
    allow(sessions_client).to receive(:create)
    allow(client).to receive(:linked_account_access).with(user).and_return(
      heidi_result(success: true, body: { "is_linked" => false })
    )
    allow(client).to receive(:link_account_url_for).with(user).and_return(
      heidi_result(
        success: true,
        body: { "url" => "https://registrar.scribe.heidihealth.com/integration/widget/auth?t=jwt" }
      )
    )

    result = launcher.call

    expect(result).to be_failed
    expect(result).to be_account_link_required
    expect(result.error).to eq("Your Renalware account is not linked to Heidi yet.")
    expect(result.link_account_url).to eq(
      "https://registrar.scribe.heidihealth.com/integration/widget/auth?t=jwt"
    )
    expect(sessions_client).not_to have_received(:create)
    expect(Renalware::Heidi::Session.count).to eq(0)
  end

  it "returns a failure when Heidi link status cannot be checked" do
    allow(sessions_client).to receive(:create)
    allow(client).to receive(:linked_account_access).with(user).and_return(
      heidi_result(success: false, error: "Heidi unavailable")
    )

    result = launcher.call

    expect(result).to be_failed
    expect(result.error).to eq("Heidi account link status could not be checked: Heidi unavailable")
    expect(sessions_client).not_to have_received(:create)
    expect(Renalware::Heidi::Session.count).to eq(0)
  end

  def allow_linked_account
    allow(client).to receive(:linked_account_access).with(user).and_return(
      heidi_result(success: true, body: { "is_linked" => true })
    )
  end

  def allow_heidi_session_created
    allow(sessions_client).to receive(:create).with(user).and_return(
      heidi_result(success: true, body: { "session_id" => "heidi-session-1" })
    )
  end

  def allow_patient_profile_linked
    allow(patient_profiles_client).to receive(:find_or_create)
      .with(user, clinic_visit.patient)
      .and_return(heidi_result(success: true, body: { "id" => "patient-profile-1" }))
    allow(patient_profiles_client).to receive(:link_session)
      .with(
        user,
        patient_profile_id: "patient-profile-1",
        session_id: "heidi-session-1"
      )
      .and_return(heidi_result(success: true, body: {}))
  end

  def allow_session_context_updated
    allow(Renalware::Heidi::SessionContextBuilder).to receive(:new)
      .with(clinic_visit.patient)
      .and_return(instance_double(Renalware::Heidi::SessionContextBuilder, call: {}))
  end

  def heidi_result(success:, body: {}, error: nil)
    Renalware::Heidi::Client::Result.new(
      success:,
      status: success ? 200 : 400,
      body:,
      error:
    )
  end
end
