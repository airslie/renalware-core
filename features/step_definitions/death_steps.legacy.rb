# frozen_string_literal: true

Given("the patient is cc'ed on letters") do
  (@patty || @patient_1).update_columns(cc_on_all_letters: true, cc_decision_on: "01-01-2013")
end

Given("the patient has prescriptions") do
  patient = @patty || @patient_1
  seed_prescription_for(patient: patient)
  expect(patient.prescriptions.count).to eq(1)
end

When("I select death modality") do
  within ".patient-content" do
    within "#modality-description-select" do
      select "Death"
    end

    fill_in "Started on", with: I18n.l(Time.zone.today)

    click_on "Save"
  end
end

Then("I should see the patient's current modality set as death with start date") do
  visit patient_modalities_path(@patty || @patient_1)

  expect(page).to have_content("Death")
  expect(page).to have_content(I18n.l(Time.zone.today))
end

Then("I should see the date of death and causes of death in the patient's clinical profile") do
  visit patient_clinical_profile_path(@patty || @patient_1)

  expect(page).to have_content(I18n.l(Time.zone.today))
  expect(page).to have_content("Dementia")
  expect(page).to have_content("Cachexia")
end

Then("I should see the patient on the death list") do
  visit patient_deaths_path
  within("#patients-deceased") do
    expect(page).to have_content("100 012 4501")
    expect(page).to have_content("M")
  end
end

When("I complete the cause of death form") do
  within ".edit_patient" do
    fill_in "Date of Death", with: I18n.l(Time.zone.today)

    select "Dementia", from: "Cause of Death (1)"
    select "Cachexia", from: "Cause of Death (2)"

    fill_in "Notes", with: "Heart stopped"

    click_on "Save"
  end
end

Then("all prescriptions should have been terminated") do
  expect(@patient_1.prescriptions.current.count).to eq(0)
end

Then("the patient should not be cc'ed on future letters") do
  @patient_1.reload
  expect(@patient_1.cc_on_all_letters).to be_falsey
  expect(@patient_1.cc_decision_on).to eq(Time.zone.today)
end
