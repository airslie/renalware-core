Feature: Following-up a donor operation

  After a transplant operation, a clinician follows up with the donor and needs
  to record information related to that operation.

  Background:
    Given Clyde is a clinician
    And Don is a patient
    And Don has a donor operation

  @web
  Scenario: A clinician created a followup for a donor's operation
    When Clyde creates a donor operation followup for Don
    Then Don's donor operation followup workup exists

  @web
  Scenario: A clinician updated a followup for a donor's operation
    Given Don has a donor operation followup
    Then Clyde can update Don's donor operation followup
