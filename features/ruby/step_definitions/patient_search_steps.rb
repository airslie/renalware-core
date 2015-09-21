When(/^I search for a patient with "(.*)"$/) do |query|
  fill_in "patient_search_input", with: query
  click_on "Find Patient"
end

When(/^I search for a patient by surname$/) do
  fill_in "patient_search_input", :with => "rabbit"
  click_on "Find Patient"
end

Then(/^the following patients are found: "(.*)"$/) do |patient_names|
  within('table.patients') do
    patient_names.split('|').each_with_index do |name, idx|
      expect(page).to have_css("tbody tr:nth-child(#{idx+1})", text: name)
    end
  end
end

