Feature: Viewing the HD MDM page

  At an MDM (Multi-Disciplinary Meeting) a patient's MDM page is displayed
  so that all parties can see and discuss the patient's treatment

  Background:
    Given Clyde is a clinician
    Given Nathalie is a nurse
    And Patty is a patient
    And Patty has these sessions
      | signed_on_by | signed_off_by | did_not_attend |
      | Nathalie     | Nathalie      |                |
      | Nathalie     |               |                |
      | Nathalie     |               | true           |

  # @wip @web
  # Scenario: A clinician displayed the MDM page at a meeting
  #   When Clyde brings up the MDM page for Patty
  #   Then the MDM displays the following sessions
  #     | signed_on_by | signed_off_by | did_not_attend |
  #     | Nathalie     |               | true           |
  #     | Nathalie     | Nathalie      |                |
