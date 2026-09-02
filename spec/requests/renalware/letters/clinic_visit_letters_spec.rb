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

  it "renders clinic visit notes as sanitized HTML in the event summary" do
    clinic_visit.update!(
      notes: "<p><strong>Assessment</strong></p><script>alert('x')</script>"
    )

    get new_patient_letters_letter_path(
      patient,
      event_type: Renalware::Clinics::ClinicVisit.name.to_s,
      event_id: clinic_visit.id,
      clinical: true
    )

    expect(response).to be_successful
    clinic_visit_summary = response.parsed_body
      .at_xpath("//article[.//h2[normalize-space()='Clinic Visit']]")
      .to_html
    expect(clinic_visit_summary).to include("<strong>Assessment</strong>")
    expect(clinic_visit_summary).not_to include("&lt;strong&gt;Assessment&lt;/strong&gt;")
    expect(clinic_visit_summary).not_to include("<script>")
  end
end
