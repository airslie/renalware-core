Feature: Writing a letter

  To officially inform the patient and/or other interested parties about
  their clinical status, an author writes a letter.

  Most of the time, letters are written after a clinic visit.  But a simple
  letter can be written at any point in time.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient

  @web @javascript
  Scenario Outline: A nurse drafted a letter
    Given Patty accepted to be CCd on all letters
    When Nathalie drafts a letter for Patty to "<recipient>" with "<ccs>" in CC
    Then Patty has a new letter for "<recipient>"
    And Patty's letter has "<all_ccs>" in CC

    Examples:
      | recipient          | ccs                | all_ccs                     |
      | her doctor         | John Doe in London | herself, John Doe in London |
      | herself            |                    | her doctor                  |
      | John Doe in London |                    | herself, her doctor         |

  @web
  Scenario: A nurse updated a letter
    Given Patty has a letter
    Then Nathalie can update Patty's letter

  @web
  Scenario: A nurse submitted an erroneous letter
    When Nathalie submits an erroneous letter
    Then the letter is not accepted