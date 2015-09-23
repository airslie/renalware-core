Feature: Complete the assessment for the recipient

  Patients being considered for a kidney transplant require a series of investigations
  which are then reviewed on a regular basis to determine suitability for a transplant.

  Background:
    Given Clyde is a clinician
    And Patty is a patient in the system

  Scenario: Draft an assessment for a transplant
    When Clyde drafts a recipient workup for Patty
    Then Patty has 1 recipient workup
