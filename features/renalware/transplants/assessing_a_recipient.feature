Feature: Assessing (workup) a Recipient

  Patients being considered for a kidney transplant require a series of investigations
  which are then reviewed on a regular basis to determine suitability for a transplant.

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web
  Scenario: Create an assessment
    When Clyde creates a recipient workup for Patty
    Then Patty's recipient workup exists

  @web
  Scenario: Update an assessment
    Given Patty has a recorded recipient workup
    When Clyde updates the assessment
    Then Patty's recipient workup gets updated
