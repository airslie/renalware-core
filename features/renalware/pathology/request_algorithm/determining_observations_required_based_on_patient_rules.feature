Feature: Determining observations required based on patient rules

  The patient pathology algorithm determines the required patient-specific observations for a patient based on the current date and the time of the last observation for that patient.

  Unlike global rules, patient rules are created for a specific patient. They are printed in the form under a separate section. A clinician defines patient rules labelling them with a free-form description.

  The clinical will determine if an observation is required when a patient-specific rule conflicts with a global rule.

  When the clinician prints the test instructions, the last_observed_at timestamp for the rule is updated.

  Scenario Outline:

    Given Patty is a patient
    And Patty has a recorded patient rule:
      | lab                   | Biochemistry        |
      | test_description      | Test for HepB       |
      | frequency_type        | <frequency_type>    |
      | last_observed_at      | <last_observed_at>  |
    And the current date is between the rule's start/end dates <within_range>
    When the patient pathology algorithm is run for Patty
    Then it is determined the patient's observation is <determination>

    Examples:
      | frequency_type | last_observed_at | within_range | determination |
      | Always         |                  | yes          | required      |
      | Always         | 1 week ago       | yes          | required      |
      | Once           |                  | yes          | required      |
      | Once           | 1 week ago       | yes          | not required  |
      | Weekly         |                  | yes          | required      |
      | Weekly         | 6 days ago       | yes          | not required  |
      | Weekly         | 7 days ago       | yes          | required      |

      | Always         |                  | no           | not required  |
      | Always         | 1 week ago       | no           | not required  |
      | Once           |                  | no           | not required  |
      | Once           | 1 week ago       | no           | not required  |
      | Weekly         |                  | no           | not required  |
      | Weekly         | 6 days ago       | no           | not required  |
      | Weekly         | 7 days ago       | no           | not required  |
