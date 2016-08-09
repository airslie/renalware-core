Feature: Determining observations required based on patient's transplant registration status

  An observation may be required depending on the patient's transplant registration status.

  Background:
    Given the date today is 12-10-2016
    And the global rule sets:
      | request_description_code     | BFF        |
      | clinic                       | Access     |
      | frequency_type               | Always     |
    And the rule set contains these rules:
      | type                         | id | operator | value     |
      | TransplantRegistrationStatus |    |          | suspended |
    And Patty is a patient
    And Clyde is a clinician

  Scenario Outline: The patient had a transplant registration status
    Given Patty is registered on the wait list
    When Clyde sets the registration status to "<status>" and the start date to "12-10-2016"
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is <determination>

     Examples:
       | status    | determination |
       | Active    | not required  |
       | Suspended | required      |


  Scenario: The patient did not have a transplant registration status
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is not required
