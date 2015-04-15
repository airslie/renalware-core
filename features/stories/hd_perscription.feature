Feature: HD Perscription

Background:
  Given there are ethnicities in the database
    And that I'm logged in
    And some patients who need renal treatment
    And I've waited for the indexes to update
    And I am on the patients list
    And I search for a patient by surname
    And I've selected the patient from the search results

@wip @javascript @elasticsearch
Scenario: Adding a HD session
  When
    And I select the HD screen
    And I select the HD perscription
    And I complete the form
  Then a nurse sees the HS perscription
    And I should be on the HS screen