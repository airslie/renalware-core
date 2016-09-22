@wip
Feature: Searching people

  System users view all people in the global directory. A user can search for a person
  by given name or family name.

  Background:
    Given Clyde is a clinician
    And these people were recorded:
      | given_name | family_name |
      | Roger      | Rabbit      |
      | Bob        | Rabbit      |
      | Jessica    | Rabbit      |
      | Mickey     | Mouse       |
      | Bugs       | Bunny       |
      | Daffy      | Duck        |

  Scenario: A clinician searched for members of the Rabbit family
    When Clyde searches for the Rabbit family members
    Then Clyde views these people:
      | given_name | family_name |
      | Roger      | Rabbit      |
      | Bob        | Rabbit      |
      | Jessica    | Rabbit      |

  Scenario: A clinician searched for all the Roger's
    When Clyde searches for people with Roger as the given name
    Then Clyde views these people:
      | given_name | family_name |
      | Roger      | Rabbit      |
