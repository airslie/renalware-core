Feature: Terminating a prescription

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web @javascript
  Scenario: A clinician terminated a prescription for a patient
    Given Patty has a recorded prescription
    When Clyde terminates the prescription for the patient
    Then Clyde is recorded as the user who terminated the prescription
