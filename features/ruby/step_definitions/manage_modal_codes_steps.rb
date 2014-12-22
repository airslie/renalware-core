Given(/^that I'm on the add a new modal page$/) do
  visit new_modal_path
end

When(/^I complete the form for a new modal$/) do
  fill_in "Modal Name",:with => "New Modal" 
end

Then(/^I should see the new modal on the modalities list$/) do
   expect(page.has_content? "New Modal").to be true
end