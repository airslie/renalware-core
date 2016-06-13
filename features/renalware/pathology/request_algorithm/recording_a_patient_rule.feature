Feature: Recording a patient rule

  A clinician adds a "free text" pathology request rule for a patient. The rule is used by the
  pathology request algorithm in order to require specific observations to be measured for an
  individual patient.

  Each patient rule includes a free text description of the test that is to be carried out which is
  the instruction that will be given to the pathology department once the request form is printed.

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
