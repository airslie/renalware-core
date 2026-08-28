describe Renalware::Heidi::LaunchClinicVisitSession do
  include ActiveJob::TestHelper

  subject(:launcher) { described_class.new(clinic_visit:, user:, client:) }

  let(:clinic_visit) { create(:clinic_visit) }
  let(:user) { create(:user) }
  let(:client) { instance_double(Renalware::Heidi::Client) }

  before do
    ActiveJob::Base.queue_adapter = :test
    clear_enqueued_jobs
  end

  it "creates a Heidi session for the clinic visit and enqueues consult-note polling" do
    allow_linked_account
    allow(client).to receive(:create_session_for_patient)
      .with(user, clinic_visit.patient)
      .and_return(
        heidi_result(
          success: true,
          body: {
            "session_id" => "heidi-session-1",
            "patient_profile_id" => "patient-profile-1"
          }
        )
      )

    expect {
      result = launcher.call

      expect(result).to be_success
      expect(result.session).to have_attributes(
        patient: clinic_visit.patient,
        clinic_visit:,
        user:,
        heidi_session_id: "heidi-session-1",
        heidi_patient_profile_id: "patient-profile-1"
      )
    }.to change(Renalware::Heidi::Session, :count).by(1)
      .and have_enqueued_job(Renalware::Heidi::SyncSessionJob)
  end

  it "returns a failure when Heidi does not create a session" do
    allow_linked_account
    allow(client).to receive(:create_session_for_patient).and_return(
      heidi_result(success: false, error: "not linked")
    )

    result = launcher.call

    expect(result).to be_failed
    expect(result.error).to eq("not linked")
    expect(Renalware::Heidi::Session.count).to eq(0)
  end

  it "returns an account-link failure when the user is not linked to Heidi" do
    allow(client).to receive(:create_session_for_patient)
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
    expect(client).not_to have_received(:create_session_for_patient)
  end

  it "returns a failure when Heidi link status cannot be checked" do
    allow(client).to receive(:create_session_for_patient)
    allow(client).to receive(:linked_account_access).with(user).and_return(
      heidi_result(success: false, error: "Heidi unavailable")
    )

    result = launcher.call

    expect(result).to be_failed
    expect(result.error).to eq("Heidi account link status could not be checked: Heidi unavailable")
    expect(client).not_to have_received(:create_session_for_patient)
  end

  def allow_linked_account
    allow(client).to receive(:linked_account_access).with(user).and_return(
      heidi_result(success: true, body: { "is_linked" => true })
    )
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
