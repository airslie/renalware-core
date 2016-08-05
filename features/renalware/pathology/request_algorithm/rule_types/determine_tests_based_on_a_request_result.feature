Feature: Determining observations required based on an observation result rule type

  Background:
    Given request description BFF requires observation description B12

  Scenario Outline:
    Given the global rule sets:
      | request_description_code     | BFF        |
      | clinic                       | Access     |
      | frequency_type               | Always     |
    And the rule set contains these rules:
      | type              | id  | operator   | value   |
      | RequestResult     | BFF | ==         | 100     |
    And Patty is a patient
    And Patty has observed an B12 value of <observation_result>
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is <determination>

    Examples:
      | observation_result | determination |
      | 99                 | not required  |
      | 100                | required      |
