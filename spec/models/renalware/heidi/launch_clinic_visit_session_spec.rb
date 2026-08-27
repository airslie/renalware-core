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
    allow(client).to receive(:create_session_for_patient).and_return(
      heidi_result(success: false, error: "not linked")
    )

    result = launcher.call

    expect(result).to be_failed
    expect(result.error).to eq("not linked")
    expect(Renalware::Heidi::Session.count).to eq(0)
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
