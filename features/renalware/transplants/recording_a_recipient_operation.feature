Feature: Recording the operation on a recipient

  A patient requires the transplant of one or many organs: kidney, pancreas or liver.
  The patient receives the organ during an operation.

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web
  Scenario: A clinician recorded a transplant operation on a recipient
    When Clyde records a recipient operation for Patty
    Then Patty has a new recipient operation

  @web
  Scenario: A clinician updated a transplant operation on a recipient
    Given Patty has a recorded recipient operation
    Then Clyde can update Patty's recipient operation

  @web
  Scenario: A clinician submitted an erroneous transplant operation on a recipient
    When Clyde submits an erroneous recipient operation
    Then the recipient operation is not accepted
