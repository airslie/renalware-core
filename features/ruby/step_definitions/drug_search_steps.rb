When(/^I search for a drug by name$/) do
  fill_in "Drug", :with => "Red"
end

Then(/^they should see the list of drugs listed in the dropdown$/) do
  within('#drug-results') do
    page.has_css?("option", :text => "Red")
  end
end
