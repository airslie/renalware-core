Feature: Terminating a prescription

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web @javascript
  Scenario: A clinician terminated a prescription for a patient
    Given Patty has a recorded prescription
    Then Clyde can terminate the prescription for the patient
