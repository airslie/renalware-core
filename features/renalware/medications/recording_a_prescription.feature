Feature: Recording a prescription

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web @javascript
  Scenario: A clinician recorded the prescription for a patient
    When Clyde records the prescription for Patty
    Then the prescription is recorded for Patty
