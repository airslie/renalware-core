@wip
Feature: Recording a HD session

  A nurse records HD session observations at the start and the end of a session.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Patty has a HD profile

  @web
  Scenario: A nurse recorded the pre-session observations
    When Nathalie records the pre-session observations for Patty
    Then Patty has a new HD session

  @web
  Scenario: A nurse updated the HD session of a patient
    Given Patty has a HD session
    Then Nathalie can update Patty's HD session