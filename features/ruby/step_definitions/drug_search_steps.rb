When(/^I search for a drug by name$/) do
  save_and_open_page
  fill_in "Drug Search", :with => "Red"  
end

Then(/^they should see the list of drugs listed in the dropdown$/) do
  # binding.pry
  within('.drug-select') do
    page.has_css?("option", :text => "Red")
  end
end