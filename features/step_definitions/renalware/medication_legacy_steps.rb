Given(/^there are medication routes in the database$/) do
  @medication_routes = [
    ["PO", "Per Oral"], ["IV", "Intravenous"],
    ["SC", "Subcutaneous"], ["IM", "Intramuscular"],
    ["Other (Please specify in notes)", "Other (Refer to notes)"]
  ]
  @medication_routes.map! do |mroute|
    Renalware::MedicationRoute.create!(name: mroute[0], full_name: mroute[1])
  end

  @po = @medication_routes[0]
  @iv = @medication_routes[1]
  @sc = @medication_routes[2]
  @im = @medication_routes[3]
  @other_med_route = @medication_routes[4]
end

When(/^they add a medication$/) do
  visit patient_medications_path(@patient_1,
    treatable_type: @patient_1.class, treatable_id: @patient_1.id)

  click_on "Add medication"
end

When(/^complete the medication form by drug type select$/) do
  select "ESA", from: "Medication Type"
  select "Epoetin Alfa (Eprex) Syringe [ESA]", from: "Select Drug"
  fill_in "Dose", with: "10mg"
  select "PO", from:  "Route"
  fill_in "Frequency & Duration", with: "Once daily"
  fill_in "Notes", with: "Review in six weeks"

  within("#new-form fieldset .row .med-form") do
    select_date("2 March #{Date.current.year - 1}", from: "Prescribed On")
  end

  click_on "Save Medication"

end

When(/^complete the medication form by drug search$/) do
  visit patient_medications_path(@patient_1)
  click_link "Add a new medication"

  fill_in "Drug", with: "amo"

  page.execute_script %Q( $('#drug_search').trigger('keydown'); )
  within(".drug-results") do
    expect(page).to have_css("li", text: "Amoxicillin")
  end

  page.find(".drug-results :last-child").click

  fill_in "Dose", with: "20mg"
  select "IV", from: "Route"
  fill_in "Frequency & Duration", with: "Twice weekly"
  fill_in "Notes", with: "Review in two weeks."

  select_date("2 February #{Date.current.year}", from: "Prescribed On")

  find(:xpath, ".//*[@value='hospital']").set(true)

  click_on "Save Medication"
end

Then(/^be able to view notes through toggling the description data\.$/) do
  expect(page).to have_content("Wants to arrange a home visit")
end

Then(/^they should see the new problems on the clinical summary$/) do
  expect(page).to have_content("Have abdominal pain, possibly kidney stones")
end

Then(/^should see the new medication on the patient's clinical summary$/) do
  visit patient_clinical_summary_path(@patient_1)

  #drug by select
  within(".drug-esa") do
    expect(page).to have_content("Epoetin Alfa")
    expect(page).to have_content("10mg")
    expect(page).to have_content("PO")
    expect(page).to have_content("Once daily")
    expect(page).to have_content("02-03-#{Date.current.year - 1}")
  end

  #drug by search
  within(".drug-drug") do
    expect(page).to have_content("Amoxicillin")
    expect(page).to have_content("20mg")
    expect(page).to have_content("IV")
    expect(page).to have_content("Twice weekly")
    expect(page).to have_content("02-02-#{Date.current.year}")
  end
end

Then(/^should see the new medication on their medications index\.$/) do
  visit patient_medications_path(@patient_1)

  within(".drug-esa") do
    expect(page).to have_content("ESA")
    expect(page).to have_content("Epoetin Alfa")
    expect(page).to have_content("10mg")
    expect(page).to have_content("PO")
    expect(page).to have_content("Once daily")
    expect(page).to have_content("02-03-#{Date.current.year - 1}")
  end

  within(".drug-drug") do
    expect(page).to have_content("Standard")
    expect(page).to have_content("Amoxicillin")
    expect(page).to have_content("20mg")
    expect(page).to have_content("IV")
    expect(page).to have_content("Twice weekly")
    expect(page).to have_content("02-02-#{Date.current.year}")
  end
end
