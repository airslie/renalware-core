Feature: Listing the letters

  System users view all letters in the system. A user applies filters to the
  different facets, such as the current state of the letter and who authored
  it. This feature allows a secretary to filter approved letters for their
  designated doctor (the author) to print.

  Background:
    Given Clyde is a clinician
    And these letters were recorded:
      | author | typist | patient        | state          | enclosures |
      | Clyde  | Clyde  | Roger Rabbit   | draft          |            |
      | Clyde  | Clyde  | Bob Rabbit     | pending_review |            |
      | Clyde  | Taylor | Jessica Rabbit | pending_review |            |
      | Walt   | Taylor | Mickey Mouse   | pending_review | something  |
      | Walt   | typist | Bugs Bunny     | approved       | something  |
      | Walt   | typist | Daffy Duck     | completed      |            |

  Scenario: A clinician listed his letters waiting for approval
    When Clyde filters on his pending review letters typed by Taylor
    Then Clyde views these letters:
      | author | typist | patient        | state          | enclosures |
      | Clyde  | Taylor | Jessica Rabbit | pending_review |            |

  Scenario: A user lists approved letters with an enclosure so these can be printed manually
    When Clyde filters on approved letters having an attachment
    Then Clyde views these letters:
      | author | typist | patient        | state          | enclosures |
      | Walt   | typist | Bugs Bunny     | approved       | something  |

# TODO: Define a representative user for printing, and create scenarios for all printing outcomes
