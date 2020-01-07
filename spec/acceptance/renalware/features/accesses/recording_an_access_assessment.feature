Feature: Recording an access assessment for a patient

  A clinician records an access assessment for a patient, in order to make sure
  the access is still adequate for HD sessions.

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web
  Scenario: A clinician recorded an access assessment
    When Clyde records an access assessment for Patty
    Then Patty has a new access assessment
