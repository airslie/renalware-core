Feature: A Doctor adds patient info on the patient's clinical summary page

Background:
  Given that I'm logged in
    And there are ethnicities in the database
    And there are modalities in the database
    And there are modality reasons in the database
    And there are edta causes of death in the database 
    And I have a patient in the database
    And they are on a patient's clinical summary

Scenario: Doctor adds a patient event
  Given there are existing patient event types in the database
  #event also known as encounter
  When they add a patient event
    And complete the patient event form
  Then they should see the new patient event on the clinical summary

@javascript
Scenario: Doctor adds a problem
  Given they go to the problem list page
    When they add some problems to the list
  When they save the problem list
  Then they should see the new problems on the clinical summary

@javascript @wip
Scenario: Doctor adds a medication for a patient
  Given there are drugs in the database
  When they add a medication
    And complete the medication form
  Then they should see the new medication on the clinical summary

@javascript @wip
Scenario: Doctor terminates a medication for a patient
  Given there are drugs in the database
  Given a patient has a medication
  When they terminate a medication
  Then they should no longer see this medication in their clinical summary
    # And should see this terminated medication in their medications history

@javascript 
Scenario: Doctor adds a modality for a patient
  Given I choose to add a modality
  When I complete the modality form
  Then I should see a patient's modality on their clinical summary

@javascript 
Scenario: Doctor adds a death modality for a patient
  Given I choose to add a modality
  When I select death modality
  Then I should complete the cause of death form
    And see the date of death in the patient's demographics
