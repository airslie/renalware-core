Feature: Determine tests based on global rule sets and multiple rules

  The global pathology algorithm checks if there are any rules which apply to the patient and lists the required tests accordingly. For any rules which apply to the patient, it also checks if it has a conjoined rule - a second rule which is also required to pass for the patient in order for the test to be required.

  A conjoined rule can be though of as a "if rule #1 is true and rule #2 is true, then the test is required for the patient.".

  The conjoined_global_rules table contains two rule_id's and also a frequency. So the frequency used by the algorithm comes from the "conjoined_global_rules.frequency" column rather than what is set on "rules.frequency" for either of the two rules.

  Scenario Outline:
    Given there exists the following global rules:
      | id                        | 3                 | 4        |
      | global_rule_set_id        | 2                 | 2        |
      | param_type                | ObservationResult | Drug     |
      | param_id                  | 429               | 185      |
      | param_comparison_operator | <                 | include? |
      | param_comparison_value    | 100               |          |

    And there exists the following global rule sets:
      | id                         | 2                 |
      | observation_description_id | 152               |
      | regime                     | Nephrology        |
      | frequency                  | Always            |
    And Patty is a patient
    And Patty has an observation result value of <observation_result>
    And Patty is currently on drug with id=185 <drug_perscribed>
    When the global pathology algorithm is ran for Patty in regime Nephrology
    Then the required pathology should includes the test <test_required>

    Examples:
      | observation_result | drug_perscribed | test_required |
      | 99                 | yes             | yes           |
      | 99                 | no              | no            |
      | 100                | yes             | no            |
      | 100                | no              | no            |
