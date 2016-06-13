Feature: Recording a patient rule

  A clinician adds a "free text" pathology request rule for a patient to the database. The rule is used
  by the pathology request algorithm and includes a free text description of the test that is to be carried out.

  Background:
    Given Patty is a patient
    And Clyde is a clinician

  #@web
  #Scenario: A clinician recorded a new patient rule
  #  When Clyde records a new patient rule for Patty
  #  Then Patty has a new patient rule

  @web
  Scenario: A clinician submitted an erroneous patient rule
    When Clyde submits an erroneous patient rule for Patty
    Then the patient rule is not accepted
