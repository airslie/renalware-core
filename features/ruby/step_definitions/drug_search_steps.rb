When(/^I search for a drug by name$/) do
  click_on "Add a new medication"
  fill_in "Drug Name", :with => "Red"
  
end

Then(/^they should see the list of drugs listed in the dropdown$/) do
  # binding.pry
  within('.drug-select') do
    assert page.has_css?("option", :text => "Red") # Don't quote me!!
  end
end