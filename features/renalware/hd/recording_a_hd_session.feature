Feature: Recording a HD session

  A nurse records HD session observations at the start and the end of a session.

  If a nurse does not have time to record the data at the start of the session, she will
  enter all the information at the end.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Patty has the HD modality
    And Patty has a recorded HD profile
    And Patty has a prescription:
      | drug_name       | dose          | frequency | route_code | provider | terminated_on | administer_on_hd |
      | Acarbose Tablet | 100 milligram | bd        | PO         | Hospital |               | true |

  @web
  Scenario: A nurse recorded the pre-session observations
    When Nathalie records the pre-session observations for Patty
    Then Patty has a new HD session

  @web
  Scenario: A nurse updated the HD session of a patient
    Given Patty has a recorded HD session
    Then Nathalie can update Patty's HD session

  @web
  Scenario: A nurse submitted an erroneous HD session for a patient
    When Nathalie submits an erroneous HD session
    Then the HD session is not accepted

  @web @wip
  Scenario: A nurse signed-off the HD session of a patient
    When Nathalie records the pre-session observations for Patty
    And Nathalie later adds post-session observations for Patty and signs off the session
    Then Patty has a signed-off session HD session
