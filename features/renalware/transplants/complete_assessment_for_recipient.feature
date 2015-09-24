Feature: Complete the transplant assessment for the recipient

  Patients being considered for a kidney transplant require a series of investigations
  which are then reviewed on a regular basis to determine suitability for a transplant.

  Background:
    Given Clyde is a clinician
    And Patty is a patient in the system

  @wip
  Scenario: Draft an assessment
    When Clyde drafts a recipient workup for Patty
    Then Patty's recipient workup exists

  @wip
  Scenario: Update an assessment
    Given Patty has a recipient workup
    When Clyde updates the assessment
    Then Patty's recipient workup gets updated