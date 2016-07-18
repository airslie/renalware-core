Feature: Recording a prescription

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web @javascript
  Scenario: A clinician recorded the prescription for a patient
    When Clyde records the prescription for Patty
    Then the prescription is recorded for Patty

  @web @javascript
  Scenario: A clinician revised the prescription for a patient
    Given Patty has a recorded prescription
    Then Clyde can revise the prescription

  @web @javascript
  Scenario: A clinician terminated a prescription for a patient
    Given Patty has a recorded prescription
    Then Clyde can terminate the prescription for the patient
