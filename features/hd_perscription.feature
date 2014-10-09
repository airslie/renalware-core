Feature: HS Perscription

Scenario:
  Given that I'm logged in
  And I've selected a patient
  And I select the HD screen
  And I select the HD perscription
  And I complete the form
  Then a nurse sees the HS perscription
  And I should be on the HS screen