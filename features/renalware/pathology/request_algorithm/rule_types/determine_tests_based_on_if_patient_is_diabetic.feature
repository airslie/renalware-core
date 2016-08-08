Feature: Determining observations required based on if patient is diabetic

  An observation may be required depending on whether or not the patient is diabetic.

  Background:
    Given request description BFF requires observation description B12

  Scenario Outline:
    Given the global rule sets:
      | request_description_code     | BFF        |
      | clinic                       | Access     |
      | frequency_type               | Always     |
    And the rule set contains these rules:
      | type              | id | operator | value      |
      | PatientIsDiabetic |    |          | true       |
    And Patty is a patient
    And Patty is a diabetic <diabetic>
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is <determination>

    Examples:
      | diabetic | determination |
      | yes      | required      |
      | no       | not required  |
