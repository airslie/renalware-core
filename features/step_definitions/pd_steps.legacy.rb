Given(/^a patient has PD$/) do
  description = Renalware::PD::ModalityDescription.first!
  FactoryGirl.create(:modality, patient: @patient_1, description: description)

  visit patient_pd_dashboard_path(@patient_1)
end

Given(/^I choose to record a new capd regime$/) do
  click_on "Add CAPD Regime"
end

Given(/^I choose to record a new apd regime$/) do
  click_on "Add APD Regime"
end

Given(/^a patient has existing CAPD Regimes$/) do
  bag_type = Renalware::PD::BagType.find_by!(
    manufacturer: "Baxter", description: "Nutrineal PD4 (Blue)"
  )

  @capd_regime_1 = FactoryGirl.create(:capd_regime,
    patient: @patient_1,
    start_date: "05-03-2015",
    end_date: "25-04-2015",
    treatment: "CAPD 4 exchanges per day",
    amino_acid_volume: 41,
    icodextrin_volume: 51,
    add_hd: false,
    regime_bags_attributes: [
      bag_type: bag_type,
      volume: 1000,
      sunday: true,
      monday: true,
      tuesday: true,
      wednesday: true,
      thursday: true,
      friday: true,
      saturday: true
    ]
  )

  bag_type = Renalware::PD::BagType.find_by!(
    manufacturer: "Baxter", description: "Extraneal (Icodextrin 7.5%) (Purple)"
  )
  @capd_regime_2 = FactoryGirl.create(:capd_regime,
    patient: @patient_1,
    start_date: "02-04-2015",
    end_date: "21-05-2015",
    treatment: "CAPD 5 exchanges per day",
    amino_acid_volume: 42,
    icodextrin_volume: 52,
    add_hd: false,
    regime_bags_attributes: [
      bag_type: bag_type,
      volume: 1000,
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
  bag_type = Renalware::PD::BagType.find_by!(
    manufacturer: "Baxter", description: "Nutrineal PD4 (Blue)"
  )

  @apd_regime_1 = FactoryGirl.create(:apd_regime,
    patient: @patient_1,
    start_date: "17-06-2015",
    end_date: "21-07-2015",
    treatment: "APD Dry Day",
    amino_acid_volume: 46,
    icodextrin_volume: 56,
    add_hd: false,
    tidal_indicator: true,
    tidal_percentage: 60,
    no_cycles_per_apd: 3,
    overnight_pd_volume: 7600,
    apd_machine_pac: "123-4567-890",
    regime_bags_attributes: [
      bag_type: bag_type,
      volume: 1000,
      sunday: true,
      monday: true,
      tuesday: true,
      wednesday: true,
      thursday: true,
      friday: true,
      saturday: true
    ]
  )

  bag_type = Renalware::PD::BagType.find_by!(
    manufacturer: "Baxter", description: "Extraneal (Icodextrin 7.5%) (Purple)"
  )

  @apd_regime_2 = FactoryGirl.create(:apd_regime,
    patient: @patient_1,
    start_date: "20-03-2015",
    end_date: "28-05-2015",
    treatment: "APD Wet Day",
    amino_acid_volume: 47,
    icodextrin_volume: 57,
    add_hd: true,
    tidal_indicator: false,
    tidal_percentage: nil,
    no_cycles_per_apd: 4,
    overnight_pd_volume: 7800,
    apd_machine_pac: "123-4567-890",
    regime_bags_attributes: [
      bag_type: bag_type,
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

  fill_in "Start date", with: "02/04/2015"
  fill_in "End date", with: "01/06/2015"

  select "1 week", from: "Delivery interval"
  select "Baxter", from: "System"

  select("CAPD 4 exchanges per day", from: "Treatment")

  check "On additional HD"

  find("input.add-bag").click

  select("Baxter Nutrineal PD4 (Blue)", from: "* Bag type")

  select("2500", from: "* Volume (ml)")

  uncheck "Tue"
  uncheck "Sat"

  within ".patient-content" do
    click_on "Save"
  end
end

When(/^I complete the form for a apd regime$/) do

  fill_in "Start date", with: "15/05/2015"
  fill_in "End date", with: "16/07/2015"
  select "2 weeks", from: "Delivery interval"

  select("APD Wet day with additional exchange", from: "Treatment")

  find("input.add-bag").click

  select("Baxter Nutrineal PD4 (Blue)", from: "* Bag type")
  select("4000", from: "* Volume (ml)")

  # TODO: Unable tp get the click behaviour on a.deselect-bag-days (to deselect
  # all days) to work here. Its a capybara issue and not worth the time resolving at this point
  # expect(page).to have_checked_field("Monday")
  # find("a.deselect-bag-days").click
  # page.should have_content # to help js finish
  # expect(page).to_not have_checked_field("Monday")

  uncheck "Tue"
  uncheck "Wed"
  uncheck "Sat"
  uncheck "Fri"

  choose("Additional manual exchange")

  # APD specific fields
  # This has changed - last fill is no longer on the regime but
  # on a bag with role 'last fill' - may need to add another bag as last_fill here?
  # fill_in "Last Fill (ml)", with: 520

  check "Has tidal?"

  select "75", from: "Tidal (%)"

  select "7:30", from: "Therapy time"

  fill_in "Cycles per session", with: 3

  fill_in "Overnight PD vol on APD", with: 3100

  fill_in "Machine PAC", with: "123-4567-890"

  within ".patient-content" do
    click_on "Save"
  end
end

When(/^I choose to edit and update the form for a capd regime$/) do
  visit patient_pd_dashboard_path(@patient_1)

  within("table.capd-regimes tbody tr:first-child") do
    click_link("Update")
  end

  fill_in "End date", with: "03/05/2015"

  click_on "Update"

  expect(page.current_path).to eq(patient_pd_dashboard_path(@patient_1))
end

When(/^I choose to edit and update the form for a apd regime$/) do
  visit patient_pd_dashboard_path(@patient_1)

  within("table.apd-regimes tbody tr:first-child") do
    click_link("Update")
  end

  select "Fresenius Sleep Safe", from: "System"
  fill_in "End date", with: "30/08/2015"

  choose "Additional manual exchange"

  click_on "Update"
end

When(/^I choose to view a capd regime$/) do
  visit patient_pd_dashboard_path(@patient_1)

  within("table.capd-regimes tbody tr:nth-child(1)") do
    click_link("View")
  end
end

When(/^I choose to view a apd regime$/) do
  visit patient_pd_dashboard_path(@patient_1)

  within("table.apd-regimes tbody tr:nth-child(1)") do
    click_link("View")
  end
end

Then(/^I should see the new capd regime on the PD info page$/) do
  within("table.capd-regimes tbody tr:first-child") do
    expect(page).to have_content("02-04-2015")
    expect(page).to have_content("01-06-2015")
    expect(page).to have_content("CAPD 4 exchanges per day")
  end

  # average daily glucose
  within("table.capd-regimes tbody tr:first-child td:nth-child(5)") do
    expect(page).to have_content("0")
  end

  within("table.capd-regimes tbody tr:first-child td:nth-child(6)") do
    expect(page).to have_content("0")
  end

  within("table.capd-regimes tbody tr:first-child td:nth-child(7)") do
    expect(page).to have_content("0")
  end
end

Then(/^I should see the new apd regime on the PD info page$/) do
  within("table.apd-regimes tbody tr:first-child") do
    expect(page).to have_content("15-05-2015")
    expect(page).to have_content("16-07-2015")
    expect(page).to have_content("APD Wet day with additional exchange")
  end

  # average daily glucose
  within("table.apd-regimes tbody tr:first-child td:nth-child(5)") do
    expect(page).to have_content("0")
  end

  within("table.apd-regimes tbody tr:first-child td:nth-child(6)") do
    expect(page).to have_content("0")
  end

  within("table.apd-regimes tbody tr:first-child td:nth-child(7)") do
    expect(page).to have_content("0")
  end
end

Then(/^the new capd regime should be current$/) do
  within(".current-regime") do
    expect(page).to have_content("02-04-2015")
    expect(page).to have_content("01-06-2015")
    expect(page).to have_content("CAPD 4 exchanges per day")
    expect(page).to have_content("On additional HD?")
    expect(page).to have_content("Yes")

    # average daily glucose
    expect(page).to have_content("1.36 % 0 ml")
    expect(page).to have_content("2.27 % 0 ml")
    expect(page).to have_content("3.86 % 0 ml")

    # pd regime bags
    expect(page).to have_content(
      "Bag type: Nutrineal PD4 (Blue), Volume: 2500ml, No. per week: 5, Days: Sun, Mon, Wed, Thu, Fri"
    )
  end
end

Then(/^the new apd regime should be current$/) do
  within(".current-regime") do
    expect(page).to have_content("15-05-2015")
    expect(page).to have_content("16-07-2015")
    expect(page).to have_content("APD Wet day with additional exchange")
    expect(page).to have_content("On additional HD?")
    expect(page).to have_content("No")
    expect(page).to have_content("Add'l manual exchange?: Yes")

    expect(page).to have_content("1.36 % 0 ml")
    expect(page).to have_content("2.27 % 0 ml")
    expect(page).to have_content("3.86 % 0 ml")

    # pd regime bags
    expect(page).to have_content(
      "Nutrineal PD4 (Blue), Volume: 4000ml, No. per week: 3, Days: Sun, Mon, Thu"
    )

    # expect(page).to have_content("Last Fill: 520")
    expect(page).to have_content("Add'l manual exchange?: Yes")
    expect(page).to have_content("Tidal?: Yes")
    expect(page).to have_content("Tidal: 75 %")
    expect(page).to have_content("Therapy time: 7:30")
    expect(page).to have_content("Cycles per session: 3")
    expect(page).to have_content("Overnight PD vol on APD: 3100")
    expect(page).to have_content("Machine PAC: 123-4567-890")
  end
end

Then(/^I should see the updated capd regime on the PD info page$/) do

  within("table.capd-regimes tbody tr:first-child") do
    expect(page).to have_content("03-05-2015")
  end
end

Then(/^I should see the updated apd regime on the PD info page$/) do
  within("table.apd-regimes tbody tr:first-child") do
    expect(page).to have_content("30-08-2015")
  end
end

Then(/^I should see the chosen capd regime details$/) do
  expect(page).to have_content("02-04-2015")
  expect(page).to have_content("21-05-2015")
  expect(page).to have_content("Treatment:")
  expect(page).to have_content("CAPD 5 exchanges per day")
  expect(page).to have_content("On additional HD?")
  expect(page).to have_content("No")

  # saved bag for this regime:
  # bag 1
  expect(page).to have_content(
    "Bag type: Extraneal (Icodextrin 7.5%) (Purple), Volume: 1000ml, No. per week: 6, Days: Sun, Mon, Wed, Thu, Fri, Sat"
  )

  # average daily glucose calculated from bags
  expect(page).to have_content("1.36% 0 ml")
  expect(page).to have_content("2.27% 0 ml")
  expect(page).to have_content("3.86% 0 ml")
end

Then(/^I should see the chosen apd regime details$/) do
  expect(page).to have_content("Start")
  expect(page).to have_content("20-03-2015")
  expect(page).to have_content("End")
  expect(page).to have_content("28-05-2015")
  expect(page).to have_content("Treatment")
  expect(page).to have_content("APD Wet Day")
  expect(page).to have_content("On additional HD?")
  expect(page).to have_content("Yes")
  # expect(page).to have_content("Last fill")
  # expect(page).to have_content("535 ml")
  expect(page).to have_content("Add'l manual exchange?")
  expect(page).to have_content("Yes")
  expect(page).to have_content("Has tidal?")
  expect(page).to have_content("No")
  expect(page).to have_content("Cycles per session")
  expect(page).to have_content("4")
  expect(page).to have_content("Overnight PD vol on APD")
  expect(page).to have_content("7800 ml")
  expect(page).to have_content("Machine PAC")
  expect(page).to have_content("123-4567-890")

  # saved bag for this regime:
  # bag 1
  expect(page).to have_content(
    "Bag type: Extraneal (Icodextrin 7.5%) (Purple), Volume: 2000ml, No. per week: 5, Days: Sun, Tue, Wed, Thu, Sat"
  )

  # average daily glucose calculated from bags
  expect(page).to have_content("1.36% 0 ml")
  expect(page).to have_content("2.27% 0 ml")
  expect(page).to have_content("3.86% 0 ml")
end
