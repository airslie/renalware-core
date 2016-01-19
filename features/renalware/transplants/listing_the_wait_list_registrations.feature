Feature: Listing the wait list registrations

  Doctors must have a way to quickly see a list of the patients on
  the transplant wait list.

  The list can be filtered by a status or a combination of statuses, or by a document attribute.

  Background:
    Given Clyde is a clinician
    And These patients are on the transplant wait list
      | patient         | status             |
      | Rabbit, Roger   | Active             |
      | Rabbit, Jessica | Suspended          |
      | Bunny, Bugs     | Transplanted       |

  @web
  Scenario: A clinician reported the list of active wait list registrations
    When Clyde views the list of active wait list registrations
    Then Clyde sees these wait list registrations
      | patient       | status |
      | Rabbit, Roger | Active |