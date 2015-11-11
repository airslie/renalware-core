Feature: Recording the operation on a recipient

  A patient requires the transplant of one or many organs: kidney, pancreas or liver.
  The patient receives the organ during an operation.

  Background:
    And Clyde is a clinician
    And Patty is a patient

  @web @wip
  Scenario: A clinician recorded a transplant operation on a recipient
    When Clyde records a recipient operation for Patty
    Then Patty has a new recipient operation

  @web
  Scenario: A clinician udpated a transplant operation on a recipient
    Given Patty has a recipient operation
    Then Clyde can update Patty's recipient operation

  @web
  Scenario: A clinician submitted an erroneous transplant operation on a recipient
    When Clyde submits an erroneous registration
    Then the recipient operation is not accepted