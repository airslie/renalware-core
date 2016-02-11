@wip
Feature: Recording an access for a patient

  A clinician records an access for a patient.

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web
  Scenario: A clinician recorded an access
    When Clyde records an access for Patty
    Then Patty has a new access

  @web
  Scenario: A clinician updated the access of a patient
    Given Patty has an access
    Then Clyde can update Patty's access

  @web
  Scenario: A clinician submitted an erroneous access for a patient
    When Clyde submits an erroneous access
    Then the access is not accepted