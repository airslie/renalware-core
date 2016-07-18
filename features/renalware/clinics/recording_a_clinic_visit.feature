Feature: Recording a clinic visit

  Background:
    Given Patty is a patient
      And Clyde is a clinician

  @web
  Scenario: A clinician created a clinic visit for a patient
    When Clyde records Patty's clinic visit
    Then Patty's clinic visit should exist

  @web
  Scenario: A clinician updated a clinic visit for a patient
    Given Patty has a recorded clinic visit
    When Clyde updates Patty's clinic visit
    Then Patty's clinic visit should be updated
