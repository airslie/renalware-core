Given(/^I choose to record a new capd regime$/) do
  click_on "Add CAPD Regime"
end

Given(/^I choose to record a new apd regime$/) do
  click_on 'Add APD Regime'
end

Given(/^a patient has existing CAPD Regimes$/) do
  @bag_type = FactoryGirl.create(:bag_type)

  @capd_regime_1 = FactoryGirl.create(:capd_regime,
    patient: @patient_1,
    start_date: "05/03/2015",
    end_date: "25/04/2015",
    treatment: "CAPD 4 exchanges per day",
    amino_acid_ml: 41,
    icodextrin_ml: 51,
    add_hd: false,
    pd_regime_bags_attributes: [
      bag_type: @bag_type_13_6,
      volume: 600,
      sunday: true,
      monday: true,
      tuesday: true,
      wednesday: true,
      thursday: true,
      friday: true,
      saturday: true
    ]
  )

  @capd_regime_2 = FactoryGirl.create(:capd_regime,
    patient: @patient_1,
    start_date: "02/04/2015",
    end_date: "21/05/2015",
    treatment: "CAPD 5 exchanges per day",
    amino_acid_ml: 42,
    icodextrin_ml: 52,
    add_hd: false,
    pd_regime_bags_attributes: [
      bag_type: @bag_type_13_6,
      volume: 600,
      sunday: true,
      monday: true,
      tuesday: false,
      wednesday: true,
      thursday: true,
      friday: true,
      saturday: true
    ]
  )

end

Given(/^a patient has existing APD Regimes$/) do
  @apd_regime_1 = FactoryGirl.create(:apd_regime,
    patient: @patient_1,
    start_date: "17/06/2015",
    end_date: "21/07/2015",
    treatment: "APD Dry Day",
    amino_acid_ml: 46,
    icodextrin_ml: 56,
    add_hd: false,
    last_fill_ml: 630,
    add_manual_exchange: false,
    tidal_indicator: true,
    tidal_percentage: 10,
    no_cycles_per_apd: 3,
    overnight_pd_ml: 7600,
    pd_regime_bags_attributes: [
      bag_type: @bag_type_22_7,
      volume: 600,
      sunday: true,
      monday: true,
      tuesday: true,
      wednesday: true,
      thursday: true,
      friday: true,
      saturday: true
    ]
  )

  @apd_regime_2 = FactoryGirl.create(:apd_regime,
    patient: @patient_1,
    start_date: "20/03/2015",
    end_date: "28/05/2015",
    treatment: "APD Wet Day",
    amino_acid_ml: 47,
    icodextrin_ml: 57,
    add_hd: true,
    last_fill_ml: 535,
    add_manual_exchange: true,
    tidal_indicator: false,
    tidal_percentage: nil,
    no_cycles_per_apd: 4,
    overnight_pd_ml: 7800,
    pd_regime_bags_attributes: [
      bag_type: @bag_type_38_6,
      volume: 2000,
      sunday: true,
      monday: false,
      tuesday: true,
      wednesday: true,
      thursday: true,
      friday: false,
      saturday: true
    ]
  )

end

When(/^I complete the form for a capd regime$/) do
  select '2015', from: 'pd_regime_start_date_1i'
  select 'April', from: 'pd_regime_start_date_2i'
  select '2', from: 'pd_regime_start_date_3i'

  select '2015', from: 'pd_regime_end_date_1i'
  select 'June', from: 'pd_regime_end_date_2i'
  select '1', from: 'pd_regime_end_date_3i'

  select('CAPD 4 exchanges per day', from: 'Treatment')

  check "On additional HD"

  find("input.add-bag").click

  select('Sunshine Brand Blue–1.36', from: 'Bag Type')
  fill_in('Volume', with: '230')

  uncheck 'Tuesday'
  uncheck 'Saturday'

  click_on "Save"
end

When(/^I complete the form for a apd regime$/) do
  select '2015', from: 'pd_regime_start_date_1i'
  select 'May', from: 'pd_regime_start_date_2i'
  select '15', from: 'pd_regime_start_date_3i'

  select '2015', from: 'pd_regime_end_date_1i'
  select 'July', from: 'pd_regime_end_date_2i'
  select '16', from: 'pd_regime_end_date_3i'

  select('APD Wet day with additional exchange', from: 'Treatment')

  find('input.add-bag').click

  select('Unicorn Brand Green–3.86', from: 'Bag Type')
  fill_in('Volume', with: '400')
  uncheck 'Tuesday'
  uncheck 'Wednesday'
  uncheck 'Saturday'
  uncheck 'Friday'

  #APD specific fields
  fill_in 'Last Fill (ml)', with: 520

  check 'Additional manual exchange'

  check 'Has tidal?'

  select '75', from: 'Tidal (%)'

  fill_in 'Number of cycles per APD session', with: 3

  fill_in 'Overnight PD volume on APD', with: 3100

  click_on "Save"
end

When(/^I choose to edit and update the form for a capd regime$/) do
  visit patient_pd_summary_path(@patient_1)

  within("table.capd-regimes tbody tr:first-child") do
    click_link('Update')
  end

  select '2015', from: 'pd_regime_end_date_1i'
  select 'May', from: 'pd_regime_end_date_2i'
  select '3', from: 'pd_regime_end_date_3i'

  click_on "Update CAPD Regime"
end

When(/^I choose to edit and update the form for a apd regime$/) do
  visit patient_pd_summary_path(@patient_1)

  within("table.apd-regimes tbody tr:first-child") do
    click_link('Update')
  end

  select '2015', from: 'pd_regime_end_date_1i'
  select 'August', from: 'pd_regime_end_date_2i'
  select '30', from: 'pd_regime_end_date_3i'

  check 'Additional manual exchange'

  click_on "Update APD Regime"
end

When(/^I choose to view a capd regime$/) do
  visit patient_pd_summary_path(@patient_1)

  within("table.capd-regimes tbody tr:nth-child(1)") do
    click_link('View')
  end
end

When(/^I choose to view a apd regime$/) do
  visit patient_pd_summary_path(@patient_1)

  within("table.apd-regimes tbody tr:nth-child(1)") do
    click_link('View')
  end
end

Then(/^I should see the new capd regime on the PD info page$/) do
  within('table.capd-regimes tbody tr:first-child') do
    expect(page).to have_content("02/04/2015")
    expect(page).to have_content("01/06/2015")
    expect(page).to have_content("CAPD 4 exchanges per day")
  end

  #average daily glucose
  within('table.capd-regimes tbody tr:first-child td:nth-child(5)') do
    expect(page).to have_content("164")
  end

  within('table.capd-regimes tbody tr:first-child td:nth-child(6)') do
    expect(page).to have_content("0")
  end

  within('table.capd-regimes tbody tr:first-child td:nth-child(7)') do
    expect(page).to have_content("0")
  end
end

Then(/^I should see the new apd regime on the PD info page$/) do
  within('table.apd-regimes tbody tr:first-child') do
    expect(page).to have_content("15/05/2015")
    expect(page).to have_content("16/07/2015")
    expect(page).to have_content("APD Wet day with additional exchange")
  end

  #average daily glucose
  within('table.apd-regimes tbody tr:first-child td:nth-child(5)') do
    expect(page).to have_content("0")
  end

  within('table.apd-regimes tbody tr:first-child td:nth-child(6)') do
    expect(page).to have_content("0")
  end

  within('table.apd-regimes tbody tr:first-child td:nth-child(7)') do
    expect(page).to have_content("171")
  end
end

Then(/^the new capd regime should be current$/) do
  within('.current-regime') do
    expect(page).to have_content("02/04/2015")
    expect(page).to have_content("01/06/2015")
    expect(page).to have_content("CAPD 4 exchanges per day")
    expect(page).to have_content("On additional HD?")
    expect(page).to have_content("Yes")

    #average daily glucose
    expect(page).to have_content("1.36 % 164 ml")
    expect(page).to have_content("2.27 % 0 ml")
    expect(page).to have_content("3.86 % 0 ml")

    #pd regime bags
    expect(page).to have_content("Bag type: Blue–1.36, Volume: 230ml, No. per week: 5, Days: Sun, Mon, Wed, Thu, Fri")
  end
end

Then(/^the new apd regime should be current$/) do
  within('.current-regime') do
    expect(page).to have_content("15/05/2015")
    expect(page).to have_content("16/07/2015")
    expect(page).to have_content("APD Wet day with additional exchange")
    expect(page).to have_content("On additional HD?")
    expect(page).to have_content("No")

    expect(page).to have_content("1.36 % 0 ml")
    expect(page).to have_content("2.27 % 0 ml")
    expect(page).to have_content("3.86 % 171 ml")

    #pd regime bags
    expect(page).to have_content("Bag type: Green–3.86, Volume: 400ml, No. per week: 3, Days: Sun, Mon, Thu")

    expect(page).to have_content("Last Fill: 520")
    expect(page).to have_content("Additional manual exchange?: Yes")
    expect(page).to have_content("Tidal?: Yes")
    expect(page).to have_content("Tidal: 75 %")
    expect(page).to have_content("Number of cycles per APD session: 3")
    expect(page).to have_content("Overnight PD volume on APD: 3100")
  end
end

Then(/^I should see the updated capd regime on the PD info page$/) do
  within('table.capd-regimes tbody tr:first-child') do
    expect(page).to have_content("03/05/2015")
  end
end

Then(/^I should see the updated apd regime on the PD info page$/) do
  within('table.apd-regimes tbody tr:first-child') do
    expect(page).to have_content("30/08/2015")
  end
end

Then(/^I should see the chosen capd regime details$/) do
  expect(page).to have_content("02/04/2015")
  expect(page).to have_content("21/05/2015")
  expect(page).to have_content("Treatment: CAPD 5 exchanges per day")
  expect(page).to have_content("On additional HD?")
  expect(page).to have_content("No")

  #saved bag for this regime:
  #bag 1
  expect(page).to have_content("Bag type: Blue–1.36, Volume: 600ml, No. per week: 6, Days: Sun, Mon, Wed, Thu, Fri, Sat")

  #average daily glucose calculated from bags
  expect(page).to have_content("1.36%: 514 ml")
  expect(page).to have_content("2.27%: 0 ml")
  expect(page).to have_content("3.86%: 0 ml")
end

Then(/^I should see the chosen apd regime details$/) do
  expect(page).to have_content("Start Date: 20/03/2015")
  expect(page).to have_content("End Date: 28/05/2015")
  expect(page).to have_content("Treatment: APD Wet Day")
  expect(page).to have_content("On additional HD?: Yes")
  expect(page).to have_content("Last fill: 535 ml")
  expect(page).to have_content("Additional manual exchange?: Yes")
  expect(page).to have_content("Has tidal?: No")
  expect(page).to have_content("Number of cycles per APD session: 4")
  expect(page).to have_content("Overnight PD volume on APD: 7800 ml")

  #saved bag for this regime:
  #bag 1
  expect(page).to have_content("Bag type: Green–3.86, Volume: 2000ml, No. per week: 5, Days: Sun, Tue, Wed, Thu, Sat")

  #average daily glucose calculated from bags
  expect(page).to have_content("1.36%: 0 ml")
  expect(page).to have_content("2.27%: 0 ml")
  expect(page).to have_content("3.86%: 1429 ml")
end

