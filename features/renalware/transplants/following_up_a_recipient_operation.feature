Feature: Following-up a recipient operation

  After a transplant operation, a clinician follows up with the patient and needs
  to record information related to that operation.

  Background:
    Given Clyde is a clinician
    And Patty is a patient
    And Patty has a recipient operation

  @web
  Scenario: A clinician created a followup for a recipient's operation
    When Clyde creates a recipient operation followup for Patty
    Then Patty's recipient operation followup workup exists

  @web
  Scenario: A clinician udpated a followup for a recipient's operation
    Given Patty has a recipient operation followup
    Then Clyde can update Patty's a recipient operation followup
