Feature: A Doctor adds patient info on the patient's clinical summary page

Background:
  Given that I'm logged in
    And there are ethnicities in the database
    And there are modality codes in the database
    And there are modality reasons in the database
    And there are edta causes of death in the database
    And some patients who need renal treatment
    And they are on a patient's clinical summary

Scenario: Doctor adds a patient event
  Note: Event also known as an 'encounter'

  Given there are existing patient event types in the database
  When they choose to add a patient event
    And complete the patient event form
  Then they should see the new patient event on the clinical summary
    And be able to view notes through toggling the description data.

@javascript
Scenario: Doctor adds a problem
  Given they go to the problem list page
    When they add some problems to the list
  When they save the problem list
  Then they should see the new problems on the clinical summary

@javascript
Scenario: Doctor adds a medication for a patient
  Given there are drugs in the database
    And there are drug types in the database
    And existing drugs have been assigned drug types
    And there are medication routes in the database
  When they add a medication
    And complete the medication form by drug type select
    And complete the medication form by drug search
  Then they should see the new medications on the clinical summary

@javascript @pending
Scenario: Doctor terminates a medication for a patient
  Given there are drugs in the database
    And there are drug types in the database
    And existing drugs have been assigned drug types
    And there are medication routes in the database
    And a patient has a medication
  When they terminate a medication
  Then they should no longer see this medication in their clinical summary
    And should see this terminated medication in their medications history

@javascript
Scenario: Doctor adds a modality for a patient
  Given I choose to add a modality
  When I complete the modality form
  Then I should see a patient's modality on their clinical summary

@javascript
Scenario: Doctor adds a death modality for a patient
  Given I choose to add a modality
  When I select death modality
  When I complete the cause of death form
  Then I should see the date of death and causes of death in the patient's demographics
    And I should see the patient on the death list
    And I should see the patient's current death modality and set date in index
