Feature: A Doctor edits a patient event type

Background:
  Given that I'm logged in
    And there are ethnicities in the database
    And I have a patient in the database
    And they are on the existing patient event types page
    And there are existing patient event types in the database


Scenario: Doctor adds a new patient event type that does not exist on the dropdown 
  #event also known as encounter
  When they edit a patient event type
    And they complete the edit patient event type form
  Then they should see the updated event type on the existing patient event type list 