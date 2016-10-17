Feature: Writing a letter

  To officially inform the patient and/or other interested parties about
  their clinical status, an author writes a letter.

  Most of the time, letters are written after a clinic visit.  But a simple
  letter can be written at any point in time.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Phylis is Patty's primary care physician
    And Sam is a social worker
    And Sam is one of Patty's contacts
    And Kate is the emergency contact for Patty

  @web @javascript
  Scenario Outline: A nurse drafted a letter
    Given Patty accepted to be CCd on all letters
    When Nathalie drafts a letter for Patty to "<recipient>" with "<manual_ccs>"
    Then "<recipient>" will receive the letter
    And all "<ccs>" will also receive the letter

    Examples:
      | recipient | manual_ccs | ccs              |
      | Phylis    | Sam        | Patty, Sam       |
      | Phylis    | Sam, Kate  | Patty, Sam, Kate |
      | Patty     |            | Phylis           |
      | Sam       |            | Patty, Phylis    |

  @web
  Scenario: A nurse drafted an erroneous letter
    When Nathalie drafts an erroneous letter
    Then the letter is not drafted
