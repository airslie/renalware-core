Feature: Writing a simple letter

  To officially inform the patient and/or other interested parties about
  their clinical status, an author writes a letter.

  Most of the time, letters are written after a clinic visit.  But a simple
  letter can be written at any point in time.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient

  @web @javascript
  Scenario Outline: A nurse drafted a simple letter
    When Nathalie drafts a simple letter for Patty addressed to <recipient>
    Then Patty has a new simple letter for <recipient>

    Examples:
      | recipient          |
      | her doctor         |
      | herself            |
      | John Doe in London |

  @web
  Scenario: A nurse updated a simple letter
    Given Patty has a simple letter
    Then Nathalie can update Patty's simple letter

  @web
  Scenario: A nurse submitted an erroneous simple letter
    When Nathalie submits an erroneous simple letter
    Then the simple letter is not accepted