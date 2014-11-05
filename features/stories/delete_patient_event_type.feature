Feature: An admin deletes a patient event type

Background:
  Given that I'm logged in
    And there are ethnicities in the database
    And I have a patient in the database
    And there are existing patient event types in the database
    And they are on the existing patient event types page

Scenario: Doctor adds a new patient event type that does not exist on the dropdown 
  #event also known as encounter
  When they delete a patient event type
  Then they should see the deleted event type removed from the existing event type list 