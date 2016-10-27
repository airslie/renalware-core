Feature: Listing a patients HD sessions

  Nurses and clinicians need a way to view all hd sessions for a patient,
  in addition to the latest x number which are displayed on the HD Dashboard.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Patty has a recorded HD profile
    And Patty has these sessions
      | signed_on_by | signed_off_by | did_not_attend |
      | Nathalie     | Nathalie      |                |
      | Nathalie     |               |                |
      | Nathalie     |               | true           |
    And These patients have these HD sessions
      | patient         | signed_on_by | signed_off_by | did_not_attend |
      | Rabbit, Roger   | Nathalie     | Nathalie      |                |
      | Rabbit, Jessica | Nathalie     |               |                |

  @web
  Scenario: A nurse listed a patient's sessions
    When Nathalie views Patty's sessions
    Then Nathalie sees all Patty's HD sessions
