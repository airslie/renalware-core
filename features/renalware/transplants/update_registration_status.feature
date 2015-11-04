Feature: Change the status of a transplant wait list registration

  Status changes to a wait list registration are recorded providing a historical log.

  Background:
    Given the transplants module is configured
    And Clyde is a clinician
    And Chloe is a clinician
    And Patty is a patient
    And Patty is registered on the wait list with this status history
      | status       | start_date | termination_date | by       |
      | Suspended    | 15-08-2015 |                  | Chloe    |
      | Active       | 15-07-2015 | 15-08-2015       | Chloe    |
      | Working Up   | 15-06-2015 | 15-07-2015       | Chloe    |

  @web
  Scenario: A clinician changed the current status of a registration
    When Clyde sets the registration status to "Transplanted" and the start date to "15-09-2015"
    Then the registration status history is
      | status       | start_date | by      | termination_date |
      | Transplanted | 15-09-2015 | Clyde   |                  |
      | Suspended    | 15-08-2015 | Chloe   | 15-09-2015       |
      | Active       | 15-07-2015 | Chloe   | 15-08-2015       |
      | Working Up   | 15-06-2015 | Chloe   | 15-07-2015       |

  Scenario: A clinician recorded retroactively a registration status
    When Clyde sets the registration status to "Waiting" and the start date to "11-08-2015"
    Then the transplant current status stays "Suspended" since "15-08-2015"
    And the status history has the following revised termination dates
      | status       | start_date | termination_date |
      | Waiting      | 11-08-2015 | 15-08-2015       |
      | Active       | 15-07-2015 | 11-08-2015       |

  @web
  Scenario: A clinician edited a registration status
    When Clyde changes the "Active" start date to "11-07-2015"
    Then the status history has the following revised statuses
      | status       | start_date | termination_date | by       |
      | Active       | 11-07-2015 | 15-08-2015       | Clyde    |
      | Working Up   | 15-06-2015 | 11-07-2015       | Chloe    |

  @web
  Scenario: A clinician deleted a registration status
    When Clyde deletes the "Active" status change
    Then the status history has the following revised termination dates
      | status       | start_date | termination_date |
      | Working Up   | 15-06-2015 | 15-08-2015       |

  @web
  Scenario: A clinician submitted an erroneous registration status
    When Clyde submits an erroneous registration status
    Then the registration status is not accepted
