Feature: Recording a patient rule

  A clinician should be able add a patient specific rule for an observation.

  @web
  Scenario:
    Given Patty is a patient
    And Clyde is a clinician
    When Clyde records a new patient rule for Patty
    Then Patty has a new patient rule
