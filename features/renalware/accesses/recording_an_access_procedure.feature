Feature: Recording an access procedure for a patient

  A clinician records an access procedure for a patient.

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web
  Scenario: A clinician recorded an access procedure
    When Clyde records an access procedure for Patty
    Then Patty has a new access procedure

  @web
  Scenario: A clinician updated the access procedure of a patient
    Given Patty has an access procedure
    Then Clyde can update Patty's access procedure

  @web
  Scenario: A clinician submitted an erroneous access procedure for a patient
    When Clyde submits an erroneous access procedure
    Then the access procedure is not accepted