Feature: Determine tests based on observation result rule type

  A rule with rule_type "ObservationResultLT" should determine the test to be required for the patient if an observation result with observation.description_id = rule.param_identifier and observation.result < rule.param_value exists for that patient.

  Otherwise if observation.result >= rule.param_value then the test should not be required for the patient.

  Scenario Outline:
    Given there exists the following global rule:
      | id                        | 1                           |
      | global_rule_set_id        | 2                           |
      | param_type                | ObservationResult           |
      | param_id                  | 765                         |
      | param_comparison_operator | <param_comparison_operator> |
      | param_comparison_value    | <param_comparison_value>    |
    And there exists the following global rule sets:
      | id                         | 2          |
      | observation_description_id | 152        |
      | regime                     | Nephrology |
      | frequency                  | Always     |
    And Patty is a patient
    And Patty has an observation result value of <observation_result>
    When the global pathology algorithm is ran for Patty in regime Nephrology
    Then the required pathology should includes the test <test_required>

    Examples:
      | observation_result | param_comparison_operator | param_comparison_value | test_required |
      | 99                 | <                         | 100                    | yes           |
      | 100                | <                         | 100                    | no            |

      | 99                 | >                         | 100                    | no            |
      | 100                | >                         | 100                    | no            |

      | 99                 | <=                        | 100                    | yes           |
      | 100                | <=                        | 100                    | yes           |

      | 99                 | >=                        | 100                    | no            |
      | 100                | >=                        | 100                    | yes           |

      | 99                 | ==                        | 100                    | no            |
      | 100                | ==                        | 100                    | yes           |
