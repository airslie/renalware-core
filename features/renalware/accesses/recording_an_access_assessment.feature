@wip
Feature: Recording an access assessment for a patient

  A clinician records an access assessment for a patient.

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web
  Scenario: A clinician recorded an access assessment
    When Clyde records an access assessment for Patty
    Then Patty has a new access assessment

  @web
  Scenario: A clinician updated the access assessment of a patient
    Given Patty has an access assessment
    Then Clyde can update Patty's access assessment

  @web
  Scenario: A clinician submitted an erroneous access assessment for a patient
    When Clyde submits an erroneous access assessment
    Then the access assessment is not accepted