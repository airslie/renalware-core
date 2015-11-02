When(/^I search for a patient with "(.*)"$/) do |query|
  fill_in "patient_search_input", with: query
  click_on "Find Patient"
end

When(/^I search for a patient by family name$/) do
  fill_in "patient_search_input", :with => "rabbit"
  click_on "Find Patient"
end

Then(/^the following patients are found: "(.*)"$/) do |patient_names|
  within("#patients") do
    patient_names.split("|").each do |name|
      expect(page).to have_content(name)
    end
  end
end

