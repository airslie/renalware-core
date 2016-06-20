@wip
Feature: Writing a clinic visit letter

  To officially inform the patient and/or other interested parties about
  the outcome of a visit to a clinic, an author writes a letter.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Doug is Patty's doctor
    And Patty has a clinic visit

  @web
  Scenario: A nurse drafted a letter
    When Nathalie drafts a clinic letter for Patty
    Then the clinic visit has a letter

  @web
  Scenario: A nurse updated a letter
    Given Patty has a letter for a clinic visit
    Then Nathalie can update Patty's clinic visit letter

  @web
  Scenario: A nurse submitted an erroneous letter
    When Nathalie submits an erroneous clinic visit letter
    Then the letter is not accepted