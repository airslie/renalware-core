# frozen_string_literal: true

describe "Managing a patient's comorbidities", js: true do
  include ActionView::RecordIdentifier

  describe "viewing comorbidities" do
    it "displays date + Yes/No/Unknown for any comorbids the patient has, and Unknown for others" do
      user = login_as_clinical
      patient = create(:patient, by: user)

      desc1 = Renalware::Problems::Comorbidities::Description.create!(name: "Xxx", position: 1)
      desc2 = Renalware::Problems::Comorbidities::Description.create!(name: "Yyy", position: 2)

      comob = patient.comorbidities.create!(
        description: desc1,
        recognised: "yes",
        recognised_at: "2010-02-01",
        by: user
      )

      visit renalware.patient_comorbidities_path(patient)

      within("table.comorbidities ##{dom_id(desc1)}") do
        expect(page).to have_content desc1.name
        expect(page).to have_content I18n.l(comob.recognised_at)
        expect(page).to have_content "Yes"
      end

      within("table.comorbidities ##{dom_id(desc2)}") do
        expect(page).to have_content desc2.name
        expect(page).to have_no_content "Unknown"
        expect(page).to have_no_content "Yes"
        expect(page).to have_no_content "No"
      end
    end
  end

  describe "editing comorbidities" do
    it do
      user = login_as_clinical
      patient = create(:patient, by: user)

      desc1 = Renalware::Problems::Comorbidities::Description.create!(name: "Xxx", position: 1)
      desc2 = Renalware::Problems::Comorbidities::Description.create!(name: "Yyy", position: 2)

      visit renalware.edit_patient_comorbidities_path(patient)

      expect(page).to have_content desc1.name
      expect(page).to have_content desc2.name

      within("##{dom_id(desc1)}") do
        choose "Yes"
        find(:css, ".flatpickr-input").set("01-01-2001")
      end

      within("##{dom_id(desc2)}") do
        choose "No"
      end

      within "#comorbidities-form" do
        click_on "Create"
      end

      expect(
        patient.reload.comorbidities.find_by(description_id: desc1.id)
      ).to have_attributes(
        recognised_at: Date.parse("01-01-2001"),
        recognised: "yes"
      )
    end
  end
end
