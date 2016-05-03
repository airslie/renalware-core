#Feature: Determining observation requests required based on global rules
#
#  Perform a Reticulocyte Count test
#    if the patient is in Nephrology
#    and their last HB observation result '<' 70
#    and their last Reticulocyte Count test was observed 28 days ago or longer
#    and their last Reticulocyte Count test was requested 14 days ago or longer.
#
#  The relevant database tables are:
#
#  pathology_observation_descriptions:
#  | id   | code | name                 |
#  | 765  | HB   | HGB                  |
#  | 1347 | RETP | Reticulocyte Percent |
#  pathology_request_descriptions:
#  | id | code | name               | required_observation_description_id | duration |
#  | 25 | RET  | RETICULOCYTE COUNT | 1347                                | 14       |
#
#  Scenario Outline:
#
#    Given the global rule:
#      | global_rule_set_id        | 1                 |
#      | param_type                | ObservationResult |
#      | param_id                  | HB                |
#      | param_comparison_operator | <                 |
#      | param_comparison_value    | 70                |
#    And the global rule sets:
#      | id                                   | 1          |
#      | observation_request_description_code | RET        |
#      | regime                               | Nephrology |
#      | frequency                            | Monthly    |
#    And Patty is a patient
#    And the following observations were recorded
#      | code | result               | observed_at             |
#      | HGB  | <observation_result> |                         |
#      | RETP | 0.5                  | <request_last_observed> |
#    When the global pathology algorithm is run for Patty in regime Nephrology
#    Then it is determined the observation is <determination>
#
#    Examples:
#      | observation_result | request_last_observed | determination |
#      | 69                 |                       | required      |
#      | 70                 |                       | not required  |
#      | 69                 | 27 days ago           | not required  |
#      | 70                 | 27 days ago           | not required  |
#      | 69                 | 28 days ago           | required      |
#      | 70                 | 28 days ago           | not required  |
#
