Feature: Listing the wait list registrations

  Doctors must have a way to quickly see a list of the patients on
  the transplant wait list.

  The list can be filtered by a status or a combination of statuses, or by a document attribute.

  Background:
    Given Clyde is a clinician
    And These patients are on the transplant wait list
      | patient         | status             | ukt_status |
      | Rabbit, Roger   | Active             | Active     |
      | Rabbit, Jessica | Suspended          |            |
      | Bunny, Bugs     | Transplanted       | Active     |
      | Rabbit, Fran    | Active             | Suspended  |

  @web
  Scenario: A clinician listed active wait list registrations
    When Clyde views the list of active wait list registrations
    Then Clyde sees these wait list registrations
      | patient       | status | ukt_status |
      | RABBIT, Roger | Active | Active     |
      | RABBIT, Fran  | Active | Suspended  |

  @web
  Scenario: A clinician listed wait list registrations where RW status does not match UKT status /
            and sees patients where RW status is Active and TT is not, or vice versa
    When Clyde views the list of registrations having a status mismatch
    Then Clyde sees these wait list registrations
      | patient         | status             | ukt_status |
      | BUNNY, Bugs     | Transplanted       | Active     |
      | RABBIT, Fran    | Active             | Suspended  |
