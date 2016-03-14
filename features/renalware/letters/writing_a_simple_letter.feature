Feature: Writing a simple letter

  To officially inform the patient and/or other interested parties about
  their clinical status, an author writes a letter.

  Most of the time, letters are written after a clinic visit.  But a simple
  letter can be written at any point in time.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient

  @web
  Scenario: A nurse drafted a simple letter of a patient
    When Nathalie drafts a simple letter for Patty
    Then Patty has a new simple letter

  @web
  Scenario: A nurse updated the simple letter of a patient
    Given Patty has a simple letter
    Then Nathalie can update Patty's simple letter

  @web
  Scenario: A nurse submitted an erroneous simple letter for a patient
    When Nathalie submits an erroneous simple letter
    Then the simple letter is not accepted