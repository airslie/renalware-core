describe "Clinic visit letters" do
  let(:patient) { create(:clinics_patient, by: @current_user) }
  let(:clinic_visit) { create(:clinic_visit, patient:, by: @current_user) }

  it "renders a draft letter for a clinic visit event" do
    get new_patient_letters_letter_path(
      patient,
      event_type: Renalware::Clinics::ClinicVisit.name.to_s,
      event_id: clinic_visit.id,
      clinical: true
    )

    expect(response).to be_successful
    expect(response.body).to include("Clinic Visit")
  end
end
