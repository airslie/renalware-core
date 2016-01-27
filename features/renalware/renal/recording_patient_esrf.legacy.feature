Feature: A Doctor records a patient's ESRF

A patient has their end stage renal failure details recorded by a clinician

Background:
  Given there are prd in the database
    And Patty is a patient
    And Clyde is a clinician
    And Clyde is logged in
    And Clyde is on Patty's ESRF summary

@javascript
Scenario: Clyde records Patty's ESRF
  When Clyde completes Patty's ESRF from
  Then Patty's ESRF details should be updated
