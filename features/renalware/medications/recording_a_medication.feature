Feature: Recording a medication

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web @javascript
  Scenario: A clinician recorded the medication for a patient
    When Clyde records the medication for Patty
    Then the medication is recorded for Patty

  @web @javascript
  Scenario: A clinician revised the medication for a patient
    Given Patty has a recorded medication
    Then Clyde can revise the medication

  @web @javascript
  Scenario: A clinician terminated a medication for a patient
    Given Patty has a recorded medication
    Then Clyde can terminate the medication for the patient
