Feature: A clinician updates a patient's renal profile

  A patient has their End Stage Renal Failure (ESRF) details recorded by a clinician

  Background:
    Given Patty is a patient
    And Clyde is a clinician
    And Clyde is logged in

  @javascript
  Scenario: A clinician recorded a patient's ESRF details
    Given Clyde has Patty's renal profile
    When Clyde submits Patty's ESRF details
    Then Patty's renal profile is updated
