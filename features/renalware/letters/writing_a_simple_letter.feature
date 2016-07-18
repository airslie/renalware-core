Feature: Writing a letter

  To officially inform the patient and/or other interested parties about
  their clinical status, an author writes a letter.

  Most of the time, letters are written after a clinic visit.  But a simple
  letter can be written at any point in time.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Doug is Patty's doctor

  @web @javascript
  Scenario Outline: A nurse drafted a letter
    Given Patty accepted to be CCd on all letters
    When Nathalie drafts a letter for Patty to "<recipient>" with "<manual_ccs>"
    Then "<recipient>" will receive the letter
    And all "<ccs>" will also receive the letter

    Examples:
      | recipient      | manual_ccs                  | ccs                                |
      | Doug           | John in London              | Patty, John in London              |
      | Doug           | John in London, Kate in Ely | Patty, John in London, Kate in Ely |
      | Patty          |                             | Doug                               |
      | John in London |                             | Patty, Doug                        |

  @web
  Scenario: A nurse revised a letter
    Given Patty has a recorded letter
    Then Nathalie can revise Patty's letter

  @web
  Scenario: A nurse drafted an erroneous letter
    When Nathalie drafts an erroneous letter
    Then the letter is not drafted