# event is also known as encounter
# Not implemented in PHP, done at DB level?
@pending
Feature: A Doctor adds a new patient event type

Background:
  Given that I'm logged in
    And there are ethnicities in the database
    And some patients who need renal treatment
    And they are adding a new patient event

Scenario: Doctor adds a new patient event type that does not exist on the dropdown
  When they add a new patient event type
    And they complete the add a new patient event type form
  Then they should see the new patient event type added to the patient event type list

Scenario: Doctor adds a new patient event type that does not exist on the dropdown
  Given there are existing patient event types in the database
    And they are on the existing patient event types page
  When they delete a patient event type
  Then they should see the deleted event type removed from the existing event type list

Scenario: Doctor adds a new patient event type that does not exist on the dropdown
  Given there are existing patient event types in the database
    And they are on the existing patient event types page
  When they edit a patient event type
    And they complete the edit patient event type form
  Then they should see the updated event type on the existing patient event type list