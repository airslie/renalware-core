Feature: Complete the transplant assessment for the recipient

  Patients being considered for a kidney transplant require a series of investigations
  which are then reviewed on a regular basis to determine suitability for a transplant.

  Background:
    Given Clyde is a clinician
    And Patty is a patient in the system

  Scenario: Draft an assessment
    When Clyde drafts a recipient workup for Patty
    Then Patty has 1 recipient workup

  Scenario: Update an assessment
    Given Patty has a recipient workup
    When Clyde updates the assessment at a given time
    Then Patty has a recipient workup updated at that time

  # Scenario: Complete an assessment
  #   When Clyde completes the recipient workup for Patty
  #   Then we see the workup has been completed
