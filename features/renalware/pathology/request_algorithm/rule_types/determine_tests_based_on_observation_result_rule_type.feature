Feature: Determine tests based on observation result rule type

  A rule with rule_type "ObservationResultLT" should determine the test to be required for the patient if an observation result with observation.description_id = rule.param_identifier and observation.result < rule.param_value exists for that patient.

  Otherwise if observation.result >= rule.param_value then the test should not be required for the patient.

  Scenario Outline:
    Given the global rule:
      | id                        | 1                           |
      | global_rule_set_id        | 2                           |
      | param_type                | ObservationResult           |
      | param_id                  | HGB                         |
      | param_comparison_operator | <param_comparison_operator> |
      | param_comparison_value    | <param_comparison_value>    |
    And the global rule sets:
      | id                           | 2          |
      | observation_description_code | B12        |
      | regime                       | Nephrology |
      | frequency                    | Always     |
    And Patty is a patient
    And Patty has observed an HGB value of <observation_result>
    When the global pathology algorithm is run for Patty in regime Nephrology
    Then it is determined the observation is <determination>

    Examples:
      | observation_result | param_comparison_operator | param_comparison_value | determination |
      | 99                 | <                         | 100                    | required      |
      | 100                | <                         | 100                    | not required  |

      | 99                 | >                         | 100                    | not required  |
      | 100                | >                         | 100                    | not required  |

      | 99                 | <=                        | 100                    | required      |
      | 100                | <=                        | 100                    | required      |

      | 99                 | >=                        | 100                    | not required  |
      | 100                | >=                        | 100                    | required      |

      | 99                 | ==                        | 100                    | not required  |
      | 100                | ==                        | 100                    | required      |
