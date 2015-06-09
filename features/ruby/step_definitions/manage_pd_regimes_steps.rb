Given(/^I choose to record a new pd regime$/) do
  click_on "Add PD Regime"
end

When(/^I complete the form for a pd regime$/) do

  select '2015', from: 'pd_regime_start_date_1i'
  select 'April', from: 'pd_regime_start_date_2i'
  select '2', from: 'pd_regime_start_date_3i'

  select '2015', from: 'pd_regime_end_date_1i'
  select 'June', from: 'pd_regime_end_date_2i'
  select '1', from: 'pd_regime_end_date_3i'

  fill_in "Daily volume of 1.36% glucose/litre (ml)", with: 15
  fill_in "Daily volume of 2.27% glucose/litre (ml)", with: 25
  fill_in "Daily volume of 3.86% glucose/litre (ml)", with: 35
  fill_in "Daily volume of amino acid soln (ml)", with: 45
  fill_in "Daily volume of icodextrin soln (ml)", with: 60

  uncheck "Low glucose degradation product (GDP)"
  check "Low sodium solution"
  check "On additional HD"

  click_on "Save PD Regime"
end

Then(/^I should see the new pd regime on the PD info page\.$/) do
  expect(page).to have_content("02/04/2015")
  expect(page).to have_content("01/06/2015")
  expect(page).to have_content("15")
  expect(page).to have_content("25")
  expect(page).to have_content("35")
  expect(page).to have_content("45")
  expect(page).to have_content("60")
  expect(page).to have_content("No")
  expect(page).to have_css("td", text: "Yes", count: 2)
end

Given(/^there are existing PD Regimes$/) do
  @pd_regime_1 = FactoryGirl.create(:pd_regime,
    patient: @patient_1,
    start_date: "05/03/2015",
    end_date: "25/04/2015",
    glucose_ml_percent_1_36: 11,
    glucose_ml_percent_2_27: 21,
    glucose_ml_percent_3_86: 31,
    amino_acid_ml: 41,
    icodextrin_ml: 51,
    low_glucose_degradation: true,
    low_sodium: true,
    additional_hd: false
    )

  @pd_regime_2 = FactoryGirl.create(:pd_regime,
    patient: @patient_1,
    start_date: "02/04/2015",
    end_date: "21/05/2015",
    glucose_ml_percent_1_36: 12,
    glucose_ml_percent_2_27: 22,
    glucose_ml_percent_3_86: 32,
    amino_acid_ml: 42,
    icodextrin_ml: 52,
    low_glucose_degradation: true,
    low_sodium: true,
    additional_hd: false
    )
end

When(/^I choose to edit and update the form for a pd regime$/) do
  find("#update-pd-regime-#{@pd_regime_1.id}").click

  select '2015', from: 'pd_regime_end_date_1i'
  select 'May', from: 'pd_regime_end_date_2i'
  select '3', from: 'pd_regime_end_date_3i'

  click_on "Update PD Regime"
end

Then(/^I should see the updated pd regime on the PD info page\.$/) do
  pending # express the regexp above with the code you wish you had
end
