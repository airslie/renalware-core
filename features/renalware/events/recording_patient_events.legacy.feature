@legacy @web
Feature: A Doctor records a patient event

Background:
  Given Patty is a patient
    And Clyde is a clinician
    And Clyde is logged in

@javascript
Scenario: Clyde records an event for Patty
  Given Clyde is on Patty's event index
  When Clyde chooses to add an event
    And records Patty's event
  Then Clyde should see Patty's new event on the events page
    And see Patty's new event in her event index
