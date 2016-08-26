@wip
Feature: Listing the letters

  Users must have a way to see all the letters in the system.

  The list can be filtered by a typist or an author or by status (TO-DO).

  Background:
    Given Clyde is a clinician
    And these letters are recorded
      | patient         | letter_status      |
      | Roger Rabbit    | draft              |
      | Jessica Rabbit  | pending_review     |
      | Bugs Bunny      | approved           |
      | Daffy Duck      | completed          |

  @web
  Scenario: A clinician reported the list of letters
    When Clyde views the list of letters
    Then Clyde sees these letters
      | patient         | letter_status      |
      | Roger Rabbit    | draft              |
      | Jessica Rabbit  | pendingreview     |
      | Bugs Bunny      | approved           |
      | Daffy Duck      | completed          |
