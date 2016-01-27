Given(/^Clyde is on Patty's ESRF summary$/) do
  visit edit_patient_esrf_path(@patty)
end

When(/^Clyde completes Patty's ESRF from$/) do
  fill_in "ESRF Date", with: fake_date

  fill_autocomplete "prd_description_auto_complete",
    with: "Cystinuria", select: "Cystinuria"

  click_on "Save"
end

Then(/^Patty's ESRF details should be updated$/) do
  within ".renal-profile" do
    expect(page).to have_content(fake_date)
    expect(page).to have_content("Cystinuria")
  end
end
