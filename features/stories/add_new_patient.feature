Feature: A secretary adds a new patient
  #@wip
  Scenario: Secretary adds a new patient
    Given that I'm logged in
      And I am on the add a new patient page
      And I've searched for a patient in the database
    When I complete the add a new patient form
    Then I should see the new patient in the Renal Patient List
      And the patient should be created