#@wip
Feature: HS Perscription

@javascript
Scenario: Adding a HD session
  Given that I'm logged in
    And some patients who need renal treatment
    And I've searched for a patient
    And I've selected the patient from the search results
    And I select the HD screen
    And I select the HD perscription
    And I complete the form
  Then a nurse sees the HS perscription
    And I should be on the HS screen