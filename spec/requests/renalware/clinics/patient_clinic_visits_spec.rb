describe "Clinic Visits Management" do
  let(:user) { @current_user }
  let(:clinic) { create(:clinic) }
  let(:patient) { create(:clinics_patient, by: user) }
  let(:valid_clinic_visit_params) do
    {
      date: Time.zone.today,
      time: Time.zone.now,
      clinic_id: clinic.id,
      did_not_attend: false,
      height: 1.75,
      weight: 89.2,
      bp: "110/78",
      urine_blood: "neg",
      urine_protein: "neg",
      urine_glucose: "high",
      notes: "Nothing unusual"
    }
  end

  describe "GET index" do
    before do
      get patient_clinic_visits_path(patient_id: patient.to_param)
    end

    it "responds successfully" do
      expect(response).to be_successful
    end
  end

  describe "GET new" do
    it "responds successfully" do
      get new_patient_clinic_visit_path(patient_id: patient.to_param)
      expect(response).to be_successful
    end

    it "shows a Heidi launch button when Heidi is configured" do
      allow(Renalware::Heidi::Client).to receive(:configured?).and_return(true)

      get new_patient_clinic_visit_path(patient_id: patient.to_param)

      expect(response.body).to include("Save and launch Heidi")
      expect(response.body).to include(heidi_preparation_path)
      expect(response.body).to include(patient_heidi_linked_account_path(patient))
      expect(response.body).to include(new_patient_heidi_linked_account_path(patient))
    end
  end

  describe "POST create" do
    it "redirects to the clinic visits index" do
      post patient_clinic_visits_path(patient_id: patient.to_param),
           params: { clinic_visit: valid_clinic_visit_params }

      expect(response).to redirect_to(patient_clinic_visits_path(patient))
    end

    it "launches Heidi after saving the clinic visit" do
      heidi_session = build_stubbed(:heidi_session, heidi_session_id: "heidi-session-1")
      launcher = instance_double(
        Renalware::Heidi::LaunchClinicVisitSession,
        call: instance_double(
          Renalware::Heidi::LaunchClinicVisitSession::Result,
          success?: true,
          session: heidi_session
        )
      )
      allow(Renalware::Heidi::LaunchClinicVisitSession).to receive(:new).and_return(launcher)

      post patient_clinic_visits_path(patient_id: patient.to_param),
           params: {
             launch_heidi: "Save and launch Heidi",
             clinic_visit: valid_clinic_visit_params
           }

      visit = patient.clinic_visits.order(:created_at).last
      expect(Renalware::Heidi::LaunchClinicVisitSession).to have_received(:new)
        .with(clinic_visit: visit, user:)
      expect(response).to be_successful
      expect(response.body).to include("https://registrar.scribe.heidihealth.com/scribe/session/heidi-session-1")
      expect(response.body).to include(edit_patient_clinic_visit_path(patient, visit))
    end

    it "shows the Heidi launch failure in the preparation tab" do
      launcher = instance_double(
        Renalware::Heidi::LaunchClinicVisitSession,
        call: instance_double(
          Renalware::Heidi::LaunchClinicVisitSession::Result,
          success?: false,
          error: "Your Renalware account is not linked to Heidi yet.",
          link_account_url: "https://registrar.scribe.heidihealth.com/integration/widget/auth?t=jwt"
        )
      )
      allow(Renalware::Heidi::LaunchClinicVisitSession).to receive(:new).and_return(launcher)

      post patient_clinic_visits_path(patient_id: patient.to_param),
           params: {
             launch_heidi: "Save and launch Heidi",
             clinic_visit: valid_clinic_visit_params
           }

      visit = patient.clinic_visits.order(:created_at).last
      expect(response).to be_successful
      expect(response.body).to include("Heidi could not be launched")
      expect(response.body).to include("Your Renalware account is not linked to Heidi yet.")
      expect(response.body).to include(
        "https://registrar.scribe.heidihealth.com/integration/widget/auth?t=jwt"
      )
      expect(response.body).to include(edit_patient_clinic_visit_path(patient, visit))
    end

    it "does not launch Heidi when the clinic visit is invalid" do
      allow(Renalware::Heidi::LaunchClinicVisitSession).to receive(:new)

      post patient_clinic_visits_path(patient_id: patient.to_param),
           params: {
             launch_heidi: "Save and launch Heidi",
             clinic_visit: valid_clinic_visit_params.merge(date: nil)
           }

      expect(Renalware::Heidi::LaunchClinicVisitSession).not_to have_received(:new)
      expect(response).to be_successful
      expect(response.body).to include("Address the validation errors before launching Heidi.")
      expect(response.body).to include(
        'data-heidi-clinic-visit-launch-close-preparation-tab-value="true"'
      )
    end
  end

  describe "GET edit" do
    let(:clinic_visit) { create(:clinic_visit, patient:, by: user) }

    before do
      get edit_patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)
    end

    it "responds successfully" do
      expect(response).to be_successful
    end

    it "shows attached Heidi session status" do
      create(
        :heidi_session,
        patient:,
        clinic_visit:,
        user:,
        consult_note_status: "CREATED"
      )

      get edit_patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)

      expect(response.body).to include("Heidi")
      expect(response.body).to include("Launched")
      expect(response.body).to include("CREATED")
    end

    it "polls the latest launched Heidi session" do
      create(
        :heidi_session,
        patient:,
        clinic_visit:,
        user:,
        status: :launched
      )

      get edit_patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)

      expect(response.body).to include("heidi-session-poller")
      expect(response.body).to include(
        patient_clinic_visit_heidi_session_path(patient, clinic_visit)
      )
    end
  end

  describe "GET heidi_session" do
    let(:clinic_visit) { create(:clinic_visit, patient:, by: user) }

    it "returns the latest Heidi session status" do
      session = create(
        :heidi_session,
        patient:,
        clinic_visit:,
        user:,
        status: :synced,
        consult_note_status: "CREATED",
        consult_note: "Heidi note",
        last_synced_at: Time.zone.parse("2026-09-02 11:30")
      )

      get patient_clinic_visit_heidi_session_path(patient, clinic_visit), headers: {
        "ACCEPT" => "application/json"
      }

      expect(response).to be_successful
      expect(response.parsed_body).to include(
        "present" => true,
        "id" => session.id,
        "status" => "synced",
        "status_label" => "Synced",
        "consult_note_status" => "CREATED",
        "consult_note" => "Heidi note",
        "synced" => true
      )
      expect(response.parsed_body["last_synced_at"]).to be_present
    end

    it "returns a blank payload when there are no Heidi sessions" do
      get patient_clinic_visit_heidi_session_path(patient, clinic_visit), headers: {
        "ACCEPT" => "application/json"
      }

      expect(response).to be_successful
      expect(response.parsed_body).to eq("present" => false)
    end
  end

  describe "GET show" do
    before do
      clinic_visit = create(:clinic_visit, patient:, by: user)
      get patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)
    end

    it "responds successfully" do
      expect(response).to be_successful
    end
  end

  describe "PUT update" do
    before do
      clinic_visit = create(:clinic_visit, patient:, by: user)
      put patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param),
          params: {
            clinic_visit: {
              date: Time.zone.today,
              time: Time.zone.now,
              did_not_attend: false,
              height: 1.75, weight: 89.2, bp: "110/70",
              urine_blood: "neg",
              urine_protein: "neg",
              urine_glucose: "high",
              notes: "Nothing unusual"
            }
          }
    end

    it "redirects to the clinic_visits index" do
      expect(response).to redirect_to(patient_clinic_visits_path(patient))
    end
  end

  describe "DELETE destroy" do
    it "deletes a clinic_visit" do
      clinic_visit = create(:clinic_visit, patient:, by: user)
      expect {
        delete patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)
      }.to change(patient.clinic_visits, :count).by(-1)
    end
  end
end
