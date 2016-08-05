Feature: Determining observations required based on patient's sex

  An observation may be required depending on the patient's sex.

  Background:
    Given the date today is 12-10-2016
    And the global rule sets:
      | request_description_code     | BFF        |
      | clinic                       | Access     |
      | frequency_type               | Always     |
    And the rule set contains these rules:
      | type         | id | operator | value |
      | PatientSexIs |    |          | M     |
    And Patty is a patient
    And Clyde is a clinician

  Scenario Outline: The algorithm determines observations required based on patient's sex
    Given Patty's sex is <sex>
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is <determination>

     Examples:
       | sex    | determination |
       | M      | required      |
       | F      | not required  |
