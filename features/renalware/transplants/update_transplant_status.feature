@wip
Feature: Update the status of a transplant

  A patient in needs of a new kidney, liver and/or pancreas is waiting for a transplant.
  We track the progress of the transplant using a "status".  This tracking is important
  and an audit trail of the changes in the status is required.

  Background:
    Given Clyde is a clinician
    And Patty is a patient in the system
    And Patty has a transplant with this status history
      | status       | start_date | termination_date |
      | X Working Up | 19/10/2015 | 22/10/2015       |
      | Active       | 22/10/2015 | 12/12/2015       |
      | Suspended    | 12/12/2015 |                  |

  Scenario: Change the transplant current status
    When Clyde sets the transplant status to "Transplanted" and the start date to "24/12/2015"
    Then the transplant current status is "Transplanted" since "24/12/2015"
    And the status history becomes
      | status       | start_date | termination_date |
      | X Working Up | 19/10/2015 | 22/10/2015       |
      | Active       | 22/10/2015 | 1/12/2015        |
      | Suspended    | 12/12/2015 | 24/12/2015       |
      | Transplanted | 24/12/2015 |                  |

  Scenario: Record a status change missing in th past
    When Clyde sets the transplant status to "Transplanted" and the start date to "1/12/2015"
    Then the transplant current status is "Suspended" since "12/12/2015"
    And the status history becomes
      | status       | start_date | termination_date |
      | X Working Up | 19/10/2015 | 22/10/2015       |
      | Active       | 22/10/2015 | 1/12/2015        |
      | Transplanted | 1/12/2015  | 12/12/2015       |
      | Suspended    | 12/12/2015 |                  |

  Scenario: Edit historical status
    When Clyde changes the "Active" start date to "21/10/2015"
    Then the status history becomes
      | status       | start_date | termination_date |
      | X Working Up | 19/10/2015 | 21/10/2015       |
      | Active       | 21/10/2015 | 1/12/2015        |
      | Suspended    | 12/12/2015 |                  |

  Scenario: Delete historical status
    When Clyde deletes the "Active" status change
    Then the status history becomes
      | status       | start_date | termination_date |
      | X Working Up | 19/10/2015 | 12/12/2015       |
      | Suspended    | 12/12/2015 |                  |


