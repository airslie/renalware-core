RSpec.describe "Creating an vaccination", :js do
  include DrugsSpecHelper
  include TurboHelper

  let(:event_date_time) { Time.zone.now }
  let(:vaccination_drug_type) { create(:drug_type, code: :vaccine, name: "Vaccine") }

  context "when adding a vaccination event through the Events page" do
    it "captures vaccine type and drug name" do
      user = login_as_clinical
      patient = create(:patient, by: user)

      create(:vaccination_event_type)
      vaccine_drug = create(:drug, name: "ABC")
      vaccine_drug.drug_types << vaccination_drug_type
      create(:vaccination_type, code: "vacc_type_a", name: "Vac Type A")
      create(:vaccination_type, code: "vacc_type_b", name: "Vac Type B")
      refresh_prescribable_drugs_materialized_view

      visit new_patient_event_path(patient)

      slim_select "Vaccination", from: "Event type"

      expect(page).to have_select "Drug", options: ["", "ABC"]

      select "Vac Type B", from: "Type"

      # wait_for_turbo_frame is only needed here because the drug dropdown
      # items are the same even though it's reloaded when the type is changed
      # I'm guessing for Vaccinations the drugs are all the same but this isn't
      # necessarily the case for all event types.
      wait_for_turbo_frame :vaccination_drugs
      select "ABC", from: "Drug"

      click_on t("btn.create")

      events = Renalware::Events::Event.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.last
      expect(event.document.type_name).to eq("Vac Type B")
      expect(event.document.drug).to eq("ABC")
      expect(l(event.date_time)).to eq(event_date_time.strftime("%d-%b-%Y %H:%M"))
    end
  end

  context "when adding a vaccination through via the virology/vaccinations" do
    it "captures extra data" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      create(:vaccination_event_type)
      create(:vaccination_type, code: "vacc_type_a", name: "Vac Type A")
      create(:vaccination_type, code: "hbv_booster", name: "HBV Booster")
      vaccine_drug1 = create(:drug, name: "ABC")
      vaccine_drug2 = create(:drug, name: "XYZ")
      vaccine_drug1.drug_types << vaccination_drug_type
      vaccine_drug2.drug_types << vaccination_drug_type
      refresh_prescribable_drugs_materialized_view

      visit new_patient_virology_vaccination_path(patient)

      # Now change vaccination type to make drugs dropdown reload
      select "HBV Booster", from: "Type"
      wait_for_turbo_frame :vaccination_drugs
      select "XYZ", from: "Drug"

      within(".form-actions", match: :first) do
        click_on t("btn.create")
      end

      events = Renalware::Virology::Vaccination.for_patient(patient)
      expect(events.length).to eq(1)
      event = events.last
      expect(event.document.type_name).to eq("HBV Booster")
      expect(event.document.drug).to eq("XYZ")
      expect(l(event.date_time)).to eq(event_date_time.strftime("%d-%b-%Y %H:%M"))

      # TODO: check we redirect back the virology dashboard
      #       (we don't atm, we go to events/)
    end
  end
end
