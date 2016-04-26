Feature: Determining observations required based on global rules

  The global pathology algorithm determines which observations are required for a patient.

  The determination is made by a set of rules where each rule decides whether or not an observation is required for a patient given the parameters.

  A rule for an observation can be based on multiple parameters i.e. rules can be have the form "if A and B then observe C" and also "if A or B then observe C".

  Scenario Outline: Determining based only on the date of the last observation and the regime.

    This scenario encodes the following rule as an example:

    Test for Vitatim B12 Serum
      if the patient is in Nephrology
      and the patient was lasted test a week ago or longer.

    Given the global rule sets:
      | id                           | 2           |
      | observation_description_code | B12         |
      | regime                       | Nephrology  |
      | frequency                    | <frequency> |
    And Patty is a patient
    And Patty was last tested for B12 <last_observed>
    When the global pathology algorithm is run for Patty in regime Nephrology
    Then it is determined the observation is <determination>

    Examples:
      | frequency | last_observed | determination |
      | Once      |               | required      |
      | Once      | 5 days ago    | not required  |
      | Always    |               | required      |
      | Always    | 5 days ago    | required      |
      | Weekly    |               | required      |
      | Weekly    | 5 days ago    | not required  |
      | Weekly    | 7 days ago    | required      |

  Scenario Outline: Determining based on date of the last observation, regime and a single parameter.

    This scenario encodes the following rule as an example:

    Test for Vitatim B12 Serum
      if the patient is in Nephrology
      and the patient was lasted test a week ago or longer
      and the patient has an observation result for HGB less than 100.

    Given the global rule:
      | id                        | 1                 |
      | global_rule_set_id        | 2                 |
      | param_type                | ObservationResult |
      | param_id                  | HGB               |
      | param_comparison_operator | <                 |
      | param_comparison_value    | 100               |
    And the global rule sets:
      | id                           | 2           |
      | observation_description_code | B12         |
      | regime                       | Nephrology  |
      | frequency                    | <frequency> |
    And Patty is a patient
    And Patty has observed an HGB value of <observation_result>
    And Patty was last tested for B12 <last_observed>
    When the global pathology algorithm is run for Patty in regime <regime>
    Then it is determined the observation is <determination>

    Examples:
      | regime     | frequency | observation_result | last_observed | determination |
      | Nephrology | Once      | 99                 |               | required      |
      | Nephrology | Once      | 100                |               | not required  |
      | Nephrology | Once      | 99                 | 5 days ago    | not required  |
      | Nephrology | Once      | 100                | 5 days ago    | not required  |

      | Nephrology | Always    | 99                 |               | required      |
      | Nephrology | Always    | 100                |               | not required  |
      | Nephrology | Always    | 99                 | 5 days ago    | required      |
      | Nephrology | Always    | 100                | 5 days ago    | not required  |

      | Nephrology | Weekly    | 99                 |               | required      |
      | Nephrology | Weekly    | 100                |               | not required  |
      | Nephrology | Weekly    | 99                 | 5 days ago    | not required  |
      | Nephrology | Weekly    | 100                | 5 days ago    | not required  |
      | Nephrology | Weekly    | 99                 | 7 days ago    | required      |
      | Nephrology | Weekly    | 100                | 7 days ago    | not required  |

  Scenario Outline: Determining based on multiple required parameters.

    Test for Vitatim B12 Serum
      if the patient is in Nephrology
      and the patient was lasted test a week ago or longer
      and the patient has an observation result for HGB less than 100
      and the patient is currently on the drug Ephedrine Tablet.

    Given the global rules:
      | id                        | 3                 | 4                |
      | global_rule_set_id        | 2                 | 2                |
      | param_type                | ObservationResult | Drug             |
      | param_id                  | HGB               | Ephedrine Tablet |
      | param_comparison_operator | <                 | include?         |
      | param_comparison_value    | 100               |                  |

    And the global rule sets:
      | id                           | 2          |
      | observation_description_code | B12        |
      | regime                       | Nephrology |
      | frequency                    | Always     |
    And Patty is a patient
    And Patty has observed an HGB value of <observation_result>
    And Patty is currently on the drug Ephedrine Tablet <drug_perscribed>
    When the global pathology algorithm is run for Patty in regime Nephrology
    Then it is determined the observation is <determination>

    Examples:
      | observation_result | drug_perscribed | determination |
      | 99                 | yes             | required      |
      | 99                 | no              | not required  |
      | 100                | yes             | not required  |
      | 100                | no              | not required  |
