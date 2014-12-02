@elasticsearch
Feature: Search for a patient
  As a clinician
  I want to quicksearch by hospital number, lastname, firstname or NHS number

  Background:
    Given there are ethnicities in the database
      And that I'm logged in
      And some patients who need renal treatment
      And I've waited for the indexes to update
      And I am on the patients list

  Scenario: A doctor searches for a patient by hospital code
    When I search for a patient by hospital centre code
    Then they will see a list of matching results for patients

  @no_php
  Scenario: A doctor searches for a patient by forename
    When I search for a patient by forename
    Then they will see a list of matching results for patients

  Scenario: A doctor searches for a patient by surname
    When I search for a patient by surname
    Then they will see a list of matching results for patients

  Scenario: A doctor searches for a patient by partial match
    When I search for a patient by the first few letters of the surname
    Then they will see a list of matching results for patients


