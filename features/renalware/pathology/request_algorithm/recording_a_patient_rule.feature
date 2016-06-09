Feature: Recording a patient rule

  A clinician adds a "free text" pathology request rule for a patient to the database. The rule is used
  by the pathology request algorithm and includes a free text description of the test that is to be carried out.

  @web
  Scenario:
    Given Patty is a patient
    And Clyde is a clinician
    When Clyde records a new patient rule for Patty
    Then Patty has a new patient rule
