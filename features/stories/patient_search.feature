@wip
Feature: Search for a patient
  As a clinician
  I want to quicksearch by hospital number, lastname, firstname or NHS number

  Background:
    Given there are ethnicities in the database
      And that I'm logged in
      And some patients who need renal treatment

  Scenario: A doctor searches for a patient
    When I search for a patient by hospital centre code
    Then they will see a list of matching results