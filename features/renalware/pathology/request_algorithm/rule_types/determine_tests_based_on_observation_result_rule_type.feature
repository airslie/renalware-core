Feature: Determining observations required based on an observation result rule type

  A rule with rule_type "ObservationResult" makes a numerical comparison on a patient's observation_result with a given value.

  Background:
    Given request description BFF requires observation description B12

  Scenario Outline:
    Given the global rule sets:
      | request_description_code     | BFF        |
      | clinic                       | Access     |
      | frequency                    | Always     |
    And the rule set contains these rules:
      | type              | id  | operator   | value   |
      | ObservationResult | HGB | <operator> | <value> |
    And Patty is a patient
    And Patty has observed an HGB value of <result>
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is <determination>

    Examples:
      | result | operator | value | determination |
      | 99     | <        | 100   | required      |
      | 100    | <        | 100   | not required  |
      | 99     | >        | 100   | not required  |
      | 100    | >        | 100   | not required  |
      | 99     | <=       | 100   | required      |
      | 100    | <=       | 100   | required      |
      | 99     | >=       | 100   | not required  |
      | 100    | >=       | 100   | required      |
      | 99     | ==       | 100   | not required  |
      | 100    | ==       | 100   | required      |
