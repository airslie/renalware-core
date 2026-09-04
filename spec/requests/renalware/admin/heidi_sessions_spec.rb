describe "Admin Heidi sessions" do
  around do |example|
    original = Renalware.config.heidi_enabled
    example.run
  ensure
    Renalware.config.heidi_enabled = original
  end

  let(:patient) do
    create(:clinics_patient, given_name: "Jane", family_name: "Lambert")
  end
  let(:other_patient) do
    create(:clinics_patient, given_name: "Amir", family_name: "Patel")
  end
  let(:clinician) do
    create(:user, given_name: "Helen", family_name: "Moore")
  end
  let(:other_clinician) do
    create(:user, given_name: "Simon", family_name: "Ng")
  end
  let(:clinic_visit) { create(:clinic_visit, patient:, date: "2026-08-12") }
  let(:letter_patient) { Renalware::Letters::Patient.find(patient.id) }
  let!(:letter) { create(:draft_letter, patient: letter_patient, event: clinic_visit) }
  let!(:older_session) do
    create(
      :heidi_session,
      clinic_visit:,
      consult_note_status: "COMPLETED",
      created_at: 2.days.ago,
      heidi_session_id: "older-heidi-session",
      last_synced_at: 1.day.ago,
      patient:,
      status: :synced,
      user: clinician
    )
  end
  let!(:newer_session) do
    create(
      :heidi_session,
      consult_note_status: "PENDING",
      created_at: 1.day.ago,
      heidi_session_id: "newer-heidi-session",
      last_synced_at: 3.days.ago,
      patient: other_patient,
      status: :launched,
      sync_error: "Waiting for Heidi to finish",
      user: other_clinician
    )
  end

  describe "GET index" do
    it "lists sessions in reverse chronological order with useful links and metadata",
       :aggregate_failures do
      get admin_heidi_sessions_path

      expect(response).to be_successful
      expect(response.body).to include(*expected_page_content)
      expect(table_session_ids).to eq(
        [newer_session.heidi_session_id, older_session.heidi_session_id]
      )
    end

    it "filters sessions by state and user" do
      get admin_heidi_sessions_path,
          params: { q: { status_eq: "synced", user_id_eq: clinician.id } }

      table_body = response.parsed_body.css("tbody").text

      expect(response).to be_successful
      expect(table_body).to include("older-heidi-session")
      expect(table_body).not_to include("newer-heidi-session")
    end

    it "has sortable user, patient, date, status and last polled columns",
       :aggregate_failures do
      get admin_heidi_sessions_path

      expect(sort_header_for?("user_family_name")).to be(true)
      expect(sort_header_for?("patient_family_name")).to be(true)
      expect(sort_header_for?("created_at")).to be(true)
      expect(sort_header_for?("status")).to be(true)
      expect(sort_header_for?("last_synced_at")).to be(true)
    end

    it "sorts by user, patient, session date, status and last polled time" do
      expect(session_ids_for(s: "user_family_name asc")).to eq(
        [older_session.heidi_session_id, newer_session.heidi_session_id]
      )
      expect(session_ids_for(s: "patient_family_name desc")).to eq(
        [newer_session.heidi_session_id, older_session.heidi_session_id]
      )
      expect(session_ids_for(s: "created_at asc")).to eq(
        [older_session.heidi_session_id, newer_session.heidi_session_id]
      )
      expect(session_ids_for(s: "status asc")).to eq(
        [newer_session.heidi_session_id, older_session.heidi_session_id]
      )
      expect(session_ids_for(s: "last_synced_at asc")).to eq(
        [newer_session.heidi_session_id, older_session.heidi_session_id]
      )
    end

    it "is linked from the admin menu" do
      Renalware.config.heidi_enabled = true

      get admin_dashboard_path

      expect(response).to be_successful
      expect(response.body).to include("Heidi Sessions")
      expect(response.body).to include(admin_heidi_sessions_path)
    end

    it "returns not found when Heidi is disabled" do
      Renalware.config.heidi_enabled = false

      get admin_heidi_sessions_path

      expect(response).to have_http_status(:not_found)
    end
  end

  context "when the user is clinical" do
    before { login_as_clinical }

    it "redirects to the dashboard" do
      get admin_heidi_sessions_path

      expect(response).to redirect_to(dashboard_path)
    end
  end

  def session_ids_for(sort_params)
    get admin_heidi_sessions_path, params: { q: sort_params }

    table_session_ids
  end

  def table_session_ids
    response.parsed_body
      .css("tbody tr")
      .map { |row| row.css("td")[8].text.strip }
  end

  def sort_header_for?(sort_key)
    sort_header_hrefs.any? { |href| href.include?(sort_key) }
  end

  def sort_header_hrefs
    response.parsed_body.css("thead a").pluck("href")
  end

  def expected_page_content
    [
      "Heidi Sessions",
      "Helen Moore",
      "Jane Lambert",
      "Simon Ng",
      "Amir Patel",
      "older-heidi-session",
      "COMPLETED",
      "Waiting for Heidi to finish",
      *expected_page_links
    ]
  end

  def expected_page_links
    [
      edit_patient_clinic_visit_path(patient, clinic_visit),
      patient_letters_letter_path(patient, letter),
      patient_clinic_visits_path(patient)
    ]
  end
end
