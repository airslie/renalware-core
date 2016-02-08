Feature: Recording a HD session

  A nurse records HD session observations at the start and the end of a session.

  If a nurse does not have time to record the data at the start of the session, she will
  enter all the information at the end.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Patty has a HD profile

  @web @wip
  Scenario: A nurse recorded the pre-session observations
    When Nathalie records the pre-session observations for Patty
    Then Patty has a new HD session

  @web @wip
  Scenario: A nurse updated the HD session of a patient
    Given Patty has a HD session
    Then Nathalie can update Patty's HD session

  @web @wip
  Scenario: A nurse submitted an erroneous HD session for a patient
    When Nathalie submits an erroneous HD session
    Then the HD session is not accepted