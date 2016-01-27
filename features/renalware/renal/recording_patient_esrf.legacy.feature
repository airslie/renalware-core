Feature: A Doctor records a patient's ESRF

  A patient has their end stage renal failure details recorded by a clinician

  Background:
    Given Patty is a patient
    And Clyde is a clinician
    And Clyde is logged in

  @javascript
  Scenario: Clyde records Patty's ESRF
    Given Clyde is on Patty's ESRF summary
    When Clyde completes Patty's ESRF from
    Then Patty's ESRF details should be updated
