Feature: Search for a Drug
  As a clinician
  I want to quick search a drug for adding a medication

  Background:
    Given that I'm logged in
      And there are ethnicities in the database
      And there are drugs in the database
      And I've waited for the indexes to update
      And some patients who need renal treatment
      And they add a medication

  @javascript @elasticsearch
  Scenario: A doctor searches for a drug
    When I search for a drug by name
    Then they should see the list of drugs listed in the dropdown
