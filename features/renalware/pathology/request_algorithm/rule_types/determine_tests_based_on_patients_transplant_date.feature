Feature: Determining observations required based on patient's transplant date

  An observation may be required depending on the date of the patient's last transplant.

  Background:
    Given the global rule sets:
      | request_description_code     | BFF        |
      | clinic                       | Access     |
      | frequency_type               | Always     |
    And the rule set contains these rules:
      | type                      | id | operator | value |
      | TransplantDateWithinWeeks |    |          | 3     |
    And Patty is a patient

  Scenario Outline: The patient has had a transplant
    Given Patty has a recorded recipient operation performed <transplant_weeks_ago> weeks ago
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is <determination>

     Examples:
       | transplant_weeks_ago | determination |
       | 2                    | required      |
       | 4                    | not required  |

  Scenario: The patient has not had a transplant
    Given the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is not required
