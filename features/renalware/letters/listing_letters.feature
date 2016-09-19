@wip
Feature: Listing the letters

  System users view all letters in the system. A user applies filters to the
  different facets, such as the current state of the letter and who authored
  it. This feature allows a secretary to filter approved letters for their
  designated doctor (the author) to print.

  TODO: filtering by typist

  Background:
    Given Clyde is a clinician
    And these letters were recorded:
      | author | patient        | state          |
      | Clyde  | Roger Rabbit   | draft          |
      | Clyde  | Jessica Rabbit | pending_review |
      | Walt   | Mickey Mouse   | pending_review |
      | Walt   | Bugs Bunny     | approved       |
      | Walt   | Daffy Duck     | completed      |

  @todo
  Scenario: A clinician listed his letters waiting for approval
    When Clyde filters on his letters pending review
    Then Clyde views these letters:
      | author | patient        | state          |
      | Clyde  | Jessica Rabbit | pending_review |
