Feature: A Doctor adds patient info on the patient's clinical summary page

Background:
  Given that I'm logged in
    And there are ethnicities in the database
    And I have a patient in the database
    And they are on a patient's clinical summary

Scenario: Doctor adds a patient event
  Given there are existing patient event types in the database
  #event also known as encounter
  When they add a patient event
    And complete the patient event form
  Then they should see the new patient event on the clinical summary

@wip
Scenario: Doctor adds a problem
  When they add a problem
    And complete the problem form
  Then they should see the new problem on the clinical summary

@wip
Scenario: Doctor adds a medication
  When they add a medication
    And complete the medication form
  Then they should see the new medication on the clinical summary
