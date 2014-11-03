Feature: A Doctor adds a new patient event type

Background:
  Given that I'm logged in
    And I have a patient in the database
    And they are adding a new patient event

Scenario: Doctor adds a new patient event type that does not exist on the dropdown 
  #event also known as encounter
  When they add a new patient event type
    And they complete the add a new patient event type form
  Then they should see the new patient event type added to the patient event type list 