Feature: Recording the dry weight

  A clinician periodically records the dry weight of a patient.

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web
  Scenario: A clinician recorded the dry weight for a patient
    When Clyde records the dry weight for Patty
    Then Patty has a new dry weight

  @web
  Scenario: A clinician udpated the dry weight of a patient
    Given Patty has a dry weight entry
    Then Clyde can update Patty's dry weight entry

  @web
  Scenario: A clinician submitted an erroneous dry weight for a patient
    When Clyde submits an erroneous dry weight
    Then the dry weight is not accepted