Feature: Change the status of a transplant wait list registration

  Status changes to a wait list registration are recorded providing a historical log.

  Background:
    Given the transplants module is configured
    And Clyde is a clinician
    And Patty is a patient
    And Patty is registered on the wait list with this status history
      | status       | start_date | termination_date |
      | Suspended    | 15-08-2015 |                  |
      | Active       | 15-07-2015 | 15-08-2015       |
      | Working Up   | 15-06-2015 | 15-07-2015       |

  @web
  Scenario: Change the current registration status
    When Clyde sets the registration status to "Transplanted" and the start date to "15-09-2015"
    Then the registration status history is
      | status       | start_date | termination_date |
      | Transplanted | 15-09-2015 |                  |
      | Suspended    | 15-08-2015 | 15-09-2015       |
      | Active       | 15-07-2015 | 15-08-2015       |
      | Working Up   | 15-06-2015 | 15-07-2015       |

  @web
  Scenario: Record a registration status retroactively
    When Clyde sets the registration status to "Waiting" and the start date to "11-08-2015"
    Then the transplant current status stays "Suspended" since "15-08-2015"
    And the status history has the following revised termination dates
      | status       | start_date | termination_date |
      | Waiting      | 11-08-2015 | 15-08-2015       |
      | Active       | 15-07-2015 | 11-08-2015       |

  @web
  Scenario: Edit historical status
    When Clyde changes the "Active" start date to "11-07-2015"
    Then the status history has the following revised termination dates
      | status       | start_date | termination_date |
      | Working Up   | 15-06-2015 | 11-07-2015       |

  @web
  Scenario: Delete historical status
    When Clyde deletes the "Active" status change
    Then the status history has the following revised termination dates
      | status       | start_date | termination_date |
      | Working Up   | 15-06-2015 | 15-08-2015       |


