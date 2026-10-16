describe "New Visit from existing Appointment" do
  describe "GET index" do
    context "with no appointment id" do
      it "does not pre-populate the form" do
        user = login_as_clinical
        patient = create(:clinics_patient, by: user)

        visit new_patient_clinic_visit_path(patient)

        expect(page).to have_field("Date", with: "")
        expect(page).to have_field("Time", with: "")
        expect(page).to have_field("Clinic", with: "")
      end
    end

    context "with an appointment id passed" do
      it "pre-populates the form with the details copied from the appointment" do
        user = login_as_clinical
        clinic = create(:clinic) # consultant: user)
        patient = create(:clinics_patient, by: user)
        appointment = create(:appointment,
                             patient:,
                             clinic:,
                             starts_at: Time.zone.now)

        visit new_patient_clinic_visit_path(patient, appointment_id: appointment.id)

        expect(page).to have_field("Date", with: l(appointment.starts_at.to_date))
        expect(page).to have_field("Time", with: appointment.starts_at.strftime("%H:%M"))
        expect(page).to have_field("Clinic", with: appointment.clinic.id.to_s)

        within ".document" do
          click_on t("btn.create")
        end

        expect(patient.clinic_visits.length).to eq(1)
        expect(appointment.reload.becomes_visit_id).to eq(patient.clinic_visits.first.id)
      end
    end
  end
end
