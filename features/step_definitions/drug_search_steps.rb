When(/^I search for a drug by name$/) do
  fill_in "Drug", :with => "Red"

  page.execute_script %Q($('.find_drug').trigger('keyup'))
end

Then(/^they should see the list of drugs listed in the dropdown$/) do
  within('#new-form .drug-results') do
    expect(page).to have_css("li", :text => "Red")
  end
end
