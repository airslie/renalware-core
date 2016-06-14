Feature: Listing the appointments

  A user views the list of appointments for clinic visits occuring in the future. This list can
  be used to see which patients need the pathology request forms printed on a given day.

  Background:
    Given Clyde is a clinician
    And Clyde is logged in
    And the date today is 07-06-2016
    And there exists the following patients:
      | Ibiere Elliott     |
      | Wendy Sears        |
      | Rochelle Hinsberry |
    And there exists the following users:
      | Emmett Eichmann |
      | Clay Haag       |
      | Levi Considine  |
    And there exists the following appointments
      | starts_at_date | starts_at_time | patient            | user            | clinic        |
      | 07-06-2016     | 10:30          | Ibiere Elliott     | Emmett Eichmann | Haemodialysis |
      | 08-06-2016     | 11:00          | Wendy Sears        | Clay Haag       | AKI           |
      | 09-06-2016     | 16:45          | Rochelle Hinsberry | Levi Considine  | Transplant    |

  @web
  Scenario: A clinician viewed the list of appointments
    When Clyde views the list of appointments
    Then Clyde should see these appointments
      | date        | starts_at | patient            | user            | clinic        |
      | 07-06-2016  | 10:30     | Ibiere Elliott     | Emmett Eichmann | Haemodialysis |
      | 08-06-2016  | 11:00     | Wendy Sears        | Clay Haag       | AKI           |
      | 09-06-2016  | 16:45     | Rochelle Hinsberry | Levi Considine  | Transplant    |

  @web
  Scenario: A clinician viewed the list of appointments sorted by patient
    When Clyde views the list of appointments
    And Clyde sorts the list by patient
    Then Clyde should see these appointments
      | date        | starts_at | patient            | user            | clinic        |
      | 07-06-2016  | 10:30     | Ibiere Elliott     | Emmett Eichmann | Haemodialysis |
      | 09-06-2016  | 16:45     | Rochelle Hinsberry | Levi Considine  | Transplant    |
      | 08-06-2016  | 11:00     | Wendy Sears        | Clay Haag       | AKI           |

  @web
  Scenario: A clinician viewed the list of appointments sorted by user
    When Clyde views the list of appointments
    And Clyde sorts the list by user
    Then Clyde should see these appointments
      | date        | starts_at | patient            | user            | clinic        |
      | 09-06-2016  | 16:45     | Rochelle Hinsberry | Levi Considine  | Transplant    |
      | 07-06-2016  | 10:30     | Ibiere Elliott     | Emmett Eichmann | Haemodialysis |
      | 08-06-2016  | 11:00     | Wendy Sears        | Clay Haag       | AKI           |

  @web
  Scenario: A clinician viewed the list of appointments sorted by clinic
    When Clyde views the list of appointments
    And Clyde sorts the list by clinic
    Then Clyde should see these appointments
      | date        | starts_at | patient            | user            | clinic        |
      | 08-06-2016  | 11:00     | Wendy Sears        | Clay Haag       | AKI           |
      | 07-06-2016  | 10:30     | Ibiere Elliott     | Emmett Eichmann | Haemodialysis |
      | 09-06-2016  | 16:45     | Rochelle Hinsberry | Levi Considine  | Transplant    |

  @web
  Scenario: A clinician viewed the list of appointments and filtered by date
    When Clyde views the list of appointments
    And Clyde filters the list by date to 08-06-2016
    Then Clyde should see these appointments
      | date        | starts_at | patient            | user            | clinic        |
      | 08-06-2016  | 11:00     | Wendy Sears        | Clay Haag       | AKI           |
