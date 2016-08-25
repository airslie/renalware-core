@wip
Feature: Listing the letters

  Users must have a way to see all the letters in the system.

  The list can be filtered by a typist or an author or by status.

  Background:
    Given Clyde is a clinician
    And These letters are recorded
      | patient         | letter_status      |
      | Rabbit, Roger   | draft              |
      | Rabbit, Jessica | pending_review     |
      | Bunny, Bugs     | approved           |
      | Duck, Daffy     | draft          |

  @web
  Scenario: A clinician reported the list of letters
    When Clyde views the list of letters
    Then Clyde sees these letters
      | patient         | letter_status      |
      | Rabbit, Roger   | draft              |
      | Rabbit, Jessica | pendingreview     |
      | Bunny, Bugs     | approved           |
      | Duck, Daffy     | draft          |
