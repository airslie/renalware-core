Given(/^I have a user in the database$/) do
  $client.query("INSERT INTO userdata VALUES (1,'daniel','*668425423DB5193AF921380129F465A6425216D0', \
    'Garland','MR',0,1,1,1,1,1,1,1,'2014-10-06',NULL,'2014-10-06 17:13:33', \
    'IT Staff','dan@dangarland.co.uk','','Renal','United Kingdom','','', \
    '447979770053','','DMG','Dan','GURU','2014-10-06 16:29:23', \
    '2014-10-06 17:13:13',1,'2014-10-06 17:13:13','2014-10-06 17:14:03',1,0, \
    NULL,0,'0',0,0)")
end

Given(/^I am on the signin page$/) do
  visit '/login.php'
end

When(/^I sign in$/) do
  find('#userinput').set 'daniel'
  find('#pass').set 'Password1'
  click_on 'Log in now'
end

Then(/^I should see my dashboard$/) do
  expect(page.has_content? "Home Screen: daniel").to be true
end