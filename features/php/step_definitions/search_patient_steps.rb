Then(/^he will see a list of matching results$/) do
  expect(page.has_content? "RABBIT").to be true
end