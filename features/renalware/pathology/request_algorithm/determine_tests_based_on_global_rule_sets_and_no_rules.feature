Feature: Determine tests based on global rule sets and no rules

  The algorithm can determine if a test is required even if there is no specific param to test.

  Scenario Outline:
    Given there exists the following global rule sets:
      | id                         | 2                 |
      | observation_description_id | 152               |
      | regime                     | Nephrology        |
      | frequency                  | <frequency>       |
    And Patty is a patient
    And Patty was last tested for vitamin B12 Serum <last_tested>
    When the global pathology algorithm is ran for Patty in regime Nephrology
    Then the required pathology should includes the test <test_required>

    Examples:
      | frequency | last_tested | test_required |
      | Once      |             | yes           |
      | Once      | 5 days ago  | no            |
      | Always    |             | yes           |
      | Always    | 5 days ago  | yes           |
      | Weekly    |             | yes           |
      | Weekly    | 5 days ago  | no            |
      | Weekly    | 7 days ago  | yes           |
