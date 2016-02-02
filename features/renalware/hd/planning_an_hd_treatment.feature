@wip
Feature: Planning an HD treatment

  A clinician plans an HD treatment for a patient by recording a profile and a set
  of preferences.

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web
  Scenario: A clinician recorded the HD preferences of a patient
    When Clyde records the HD preferences of Patty
    Then Patty has new HD preferences

  @web
  Scenario: A clinician udpated the HD preferences of a patient
    Given Patty has HD preferences
    Then Clyde can update Patty's HD preferences