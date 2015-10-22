Feature: Change the status of a transplant wait list registration

  Status changes to a wait list registration are recorded providing a historical log.

  Background:
    Given Clyde is a clinician
    And Patty is a patient in the system
    And Patty is registered on the wait list with this status history
      | status       | start_date | termination_date |
      | Suspended    | 12-12-2015 |                  |
      | Active       | 22-10-2015 | 12-12-2015       |
      | X Working Up | 19-10-2015 | 22-10-2015       |

  @wip
  Scenario: Change the current registration status
    When Clyde sets the registration status to "Transplanted" and the start date to "24-12-2015"
    Then the registration status history is
      | status       | start_date | termination_date |
      | Transplanted | 24-12-2015 |                  |
      | Suspended    | 12-12-2015 | 24-12-2015       |
      | Active       | 22-10-2015 | 12-12-2015       |
      | X Working Up | 19-10-2015 | 22-10-2015       |

  @wip
  Scenario: Record a registration status retroactively
    When Clyde sets the registration status to "Boo" and the start date to "1-12-2015"
    Then the transplant current status stays "Suspended" since "12-12-2015"
    And the status history has the following revised termination dates
      | status       | start_date | termination_date |
      | Boo          | 01-12-2015 | 12-12-2015       |
      | Active       | 22-10-2015 | 01-12-2015       |

  @wip
  Scenario: Edit historical status
    When Clyde changes the "Active" start date to "21-10-2015"
    Then the status history has the following revised termination dates
      | status       | start_date | termination_date |
      | X Working Up | 19-10-2015 | 21-10-2015       |

  @wip
  Scenario: Delete historical status
    When Clyde deletes the "Active" status change
    Then the status history has the following revised termination dates
      | status       | start_date | termination_date |
      | X Working Up | 19-10-2015 | 12-12-2015       |


