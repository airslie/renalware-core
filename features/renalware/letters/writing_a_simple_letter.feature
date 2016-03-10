Feature: Writing a simple letter

  An author writes a letter to one of three possible recipients: the patient's doctor,
  the patient itself or someone else.

  A description must be selected.

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