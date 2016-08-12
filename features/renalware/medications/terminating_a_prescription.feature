Feature: Terminating a prescription

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web @javascript
  Scenario: A clinician terminated a prescription for a patient
    Given Patty has a recorded prescription
    When Clyde terminates the prescription for the patient
    Then Clyde is recorded as the user who terminated the prescription

  @web @javascript
  Scenario: A clinician recorded an invalid termination for a prescription
    Given Patty has a recorded prescription
    When Clyde records an invalid termination for a prescription
    Then the prescription termination is rejected
