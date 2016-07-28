Feature: Recording a prescription

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web @javascript
  Scenario: A clinician recorded the prescription for a patient
    When Clyde records the prescription for Patty
    Then the prescription is recorded for Patty

  @web @javascript @wip
  Scenario: A clinician recorded the prescription for a patient
    When Clyde records the prescription for Patty with a termination date
    Then the prescription is recorded for Patty
    And Clyde is recorded as the user who terminated the prescription
