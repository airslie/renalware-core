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

  uncheck "Low glucose degradation product (GDP)"
  check "Low sodium solution"
  check "On additional HD"

  find("input.add-bag").click

  select('Sunshine Brand Blue–2.34', from: 'Bag Type')
  fill_in('Volume', with: '2')
  select('5', from: 'Per week')
  check('Monday')
  check('Wednesday')
  check('Thursday')
  check('Friday')
  check('Sunday')

  click_on "Save PD Regime"
end

Then(/^I should see the new pd regime on the PD info page\.$/) do
  expect(page).to have_content("02/04/2015")
  expect(page).to have_content("01/06/2015")
  expect(page).to have_content("No")
  expect(page).to have_css("td", text: "Yes", count: 2)
end

Then(/^the new pd regime should be current$/) do
  within('.current-regime') do
    expect(page).to have_content('Regime Start Date: 02/04/2015')
    expect(page).to have_content('Regime End Date: 01/06/2015')
    expect(page).to have_content('Bag type: Blue–2.34, Volume: 2ml, No. per week: 5, Days: Sun, Mon, Wed, Thu, Fri')
    expect(page).to have_content('Bag Solution Indicators: Low glucose degradation(GDP): No Low sodium: Yes')
    expect(page).to have_content('On additional HD: Yes')
  end
end

Given(/^a patient has existing PD Regimes$/) do

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

  @pd_regime_bag_1 = FactoryGirl.create(:pd_regime_bag,
    bag_type: @bag_type_1,
    volume: 10,
    per_week: 2,
    monday: false,
    tuesday: false,
    wednesday: true,
    thursday: false,
    friday: true,
    saturday: false,
    sunday: false,
    )

  @pd_regime_bag_2 = FactoryGirl.create(:pd_regime_bag,
    bag_type: @bag_type_2,
    volume: 20,
    per_week: 4,
    monday: true,
    tuesday: false,
    wednesday: true,
    thursday: false,
    friday: true,
    saturday: false,
    sunday: true,
    )

  @pd_regime_2.pd_regime_bags << @pd_regime_bag_1
  @pd_regime_2.pd_regime_bags << @pd_regime_bag_2

end

When(/^I choose to edit and update the form for a pd regime$/) do
  visit pd_info_patient_path(@patient_1)

  within("table.pd-regimes tbody tr:first-child") do
    click_link('Update')
  end

  select '2015', from: 'pd_regime_end_date_1i'
  select 'May', from: 'pd_regime_end_date_2i'
  select '3', from: 'pd_regime_end_date_3i'

  click_on "Update PD Regime"
end

Then(/^I should see the updated pd regime on the PD info page\.$/) do
  expect(page).to have_content("03/05/2015")
end

When(/^I choose to view a pd regime$/) do
  visit pd_info_patient_path(@patient_1)

  within("table.pd-regimes tbody tr:nth-child(2)") do
    click_link('View Regime')
  end
end

Then(/^I should see the chosen pd regime details$/) do
  expect(page).to have_content("02/04/2015")
  expect(page).to have_content("21/05/2015")
  expect(page).to have_content("Low glucose degradation(GDP): Yes")
  expect(page).to have_content("Low sodium: Yes")
  expect(page).to have_content("On additional HD: No")

  #saved bags for this regime:
  #bag 1
  expect(page).to have_content("Bag type: Blue–2.34")
  expect(page).to have_content("Volume: 10ml")
  expect(page).to have_content("No. per week: 2")
  expect(page).to have_content("Days: Wed, Fri")

  #bag 2
  expect(page).to have_content("Bag type: Red–3.25")
  expect(page).to have_content("Volume: 20ml")
  expect(page).to have_content("No. per week: 4")
  expect(page).to have_content("Days: Sun, Mon, Wed, Fri")
end
