Feature: Listing the letters

  System users view all letters in the system. A user applies filters to the
  different facets, such as the current state of the letter and who authored
  it. This feature allows a secretary to filter approved letters for their
  designated doctor (the author) to print.

  TODO: filtering by typist

  Background:
    Given Clyde is a clinician
    And these letters were recorded:
      | author | typist | patient        | state          |
      | Clyde  | Clyde  | Roger Rabbit   | draft          |
      | Clyde  | Clyde  | Bob Rabbit     | pending_review |
      | Clyde  | Taylor | Jessica Rabbit | pending_review |
      | Walt   | Taylor | Mickey Mouse   | pending_review |
      | Walt   | typist | Bugs Bunny     | approved       |
      | Walt   | typist | Daffy Duck     | completed      |

  @todo
  Scenario: A clinician listed his letters waiting for approval
    When Clyde filters on his pending review letters typed by Taylor
    Then Clyde views these letters:
      | author | typist | patient        | state          |
      | Clyde  | Taylor | Jessica Rabbit | pending_review |
