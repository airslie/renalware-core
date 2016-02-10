@wip
Feature: Listing the HD sessions

  Nurses must have a way to quickly see the ongoing HD sessions (not signed off).
  The list can be filtered by hostipal unit and sorting using some of the fields.

  For a given patient, the user must have a way to see a paginated list of all her
  HD sessions.

  Background:
    Given Clyde is a clinician
    And These patients have these HD sessions
      | patient         | signed_on_by | signed_off_by |
      | Rabbit, Roger   | Clyde        | Nathalie      |
      | Rabbit, Jessica | Clyde        |               |
      | Bunny, Bugs     | Nathalie     | Clyde         |

  @web
  Scenario: A clinician reported the list of ongoing HD sessions
    When Clyde views the list of ongoing HD sessions
    Then Clyde sees these HD sessions
      | patient         | signed_on_by | signed_off_by |
      | Rabbit, Jessica | Clyde        |               |
