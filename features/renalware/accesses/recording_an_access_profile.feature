Feature: Recording an access profile for a patient

  A clinician records an access profile for a patient for tracking the
  information about the access to eventually be used during a HD session.

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web
  Scenario: A clinician recorded an access profile
    When Clyde records an access profile for Patty
    Then Patty has a new access profile

  @web
  Scenario: A clinician updated the access profile of a patient
    Given Patty has a recorded access profile
    Then Clyde can update Patty's access profile

  @web
  Scenario: A clinician submitted an erroneous access profile for a patient
    When Clyde submits an erroneous access profile
    Then the access profile is not accepted