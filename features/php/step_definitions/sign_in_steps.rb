Given(/^I have a user in the database$/) do
  mysql_client.query("INSERT IGNORE INTO userdata VALUES (1,'daniel',
    '*7EE969BBE0A3985C8BFF9FA65A06345C67FE434A', \
    'Garland','Dan',0,1,1,1,1,1,1,1,'2014-10-07',NULL,'2014-10-07 15:53:05', \
    'IT Staff','dan@dangarland.co.uk','kings','Renal','United Kingdom','','', \
    '447979770053','','DMG','Dan','Guru','2014-10-07 15:52:35', \
    '2014-10-09 17:15:04',1,'2014-10-09 17:15:04','2014-10-09 17:15:05', \
    1,0,NULL,0,'0',0,0)")
  mysql_client.query 'commit'
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

Given(/^that I'm logged in$/) do
  step 'I have a user in the database'
  step 'I am on the signin page'
  step 'I sign in'
end