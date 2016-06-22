Feature: Generating request forms from appointments

  A clinician views a list of appointments on a given day and chooses to generate the pathology
  request forms for all of the patients on that list or for a selection of patients from the list.

  The request forms must be given in the same order as they are listed on the appointments table.

  Background:
    Given Clyde is a clinician
    And the date today is 07-06-2016
    And the following appointments:
      | starts_at_date | starts_at_time | patient            | user            | clinic |
      | 07-06-2016     | 10:30          | Ibiere Elliott     | Emmett Eichmann | Access |
      | 08-06-2016     | 11:00          | Wendy Sears        | Clay Haag       | Access |
      | 09-06-2016     | 16:45          | Rochelle Hinsberry | Levi Considine  | Access |
    And the global rule sets:
      | request_description_code | BFF        |
      | clinic                   | Access     |
      | frequency_type           | Always     |

  @web
  Scenario: A clinician generated the forms for all appointments listed
    When Clyde generates the request forms for the appointments
    Then Clyde sees the requests forms for these patients:
      | patient            |
      | Ibiere Elliott     |
      | Wendy Sears        |
      | Rochelle Hinsberry |

  @web
  Scenario: A clinician changed the order of appointments and generated the forms for all appointments listed
    When Clyde generates the request forms for the appointments sorted by user
    Then Clyde sees the requests forms for these patients:
      | patient            | user            |
      | Rochelle Hinsberry | Levi Considine  |
      | Ibiere Elliott     | Emmett Eichmann |
      | Wendy Sears        | Clay Haag       |
