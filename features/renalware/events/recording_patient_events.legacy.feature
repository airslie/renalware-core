Feature: A Doctor records a patient event

Background:
  Given there are edta causes of death in the database
    And Patty is a patient
    And Clyde is a clinician
    And Clyde is logged in
    And Clyde is on Patty's event index

Scenario: Clyde records an event for Patty
  When Clyde chooses to add an event
    And records Patty's event
  Then Clyde should see Patty's new event on the clinical summary
    And see Patty's new event in her event index
