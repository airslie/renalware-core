Feature: Listing the letters

  System users view all letters in the system. A user applies filters to the
  different facets, such as the current state of the letter and who authored
  it. This feature allows a secretary to filter approved letters for their
  designated doctor (the author) to print.

  TODO: filtering by author & typist

  Background:
    Given Clyde is a clinician
    And these letters were recorded:
      | patient         | state              |
      | Roger Rabbit    | draft              |
      | Jessica Rabbit  | pending_review     |
      | Bugs Bunny      | approved           |
      | Daffy Duck      | completed          |

  @todo
  Scenario: A clinician listed all letters waiting for approval
    When Clyde filters on all letters pending review
    Then Clyde views these letters:
      | patient         | state              |
      | Jessica Rabbit  | pending_review     |
