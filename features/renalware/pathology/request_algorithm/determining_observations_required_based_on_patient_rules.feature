Feature: Determining observations required based on patient rules

  The patient pathology algorithm determines if there were any patient specific observations added that apply to the patient based on the current date and the time of the last observation.

  The patient_rules tables contains rules which are specific to a patient and will be printed in the form under a separate section. These are rules for tests are defined by the clinician in a text field "test_description".

  Its possible the clinician may define a patient specific test which has already been determined as required by the global rules algorithm, in which case its up to the clinician to decide what to do.

  The last_observed_at column is updated every time the test instruction is printed.

  Scenario Outline:

    Given Patty is a patient
    And Patty has a patient rule:
      | lab                   | Biochem             |
      | test_description      | Test for antibodies |
      | sample_number_bottles | 1                   |
      | sample_type           | ...                 |
      | frequency             | <frequency>         |
      | patient               | Patty               |
      | last_observed_at      | <last_observed_at>  |
    And the current date is between the start/end dates <within_range>
    When the patient pathology algorithm is run for Patty
    Then it is determined the patient's observation is <determination>

    Examples:
      | frequency | last_observed_at | within_range | determination |
      | Always    |                  | yes          | required      |
      | Always    | 1 week ago       | yes          | required      |
      | Once      |                  | yes          | required      |
      | Once      | 1 week ago       | yes          | not required  |
      | Weekly    |                  | yes          | required      |
      | Weekly    | 6 days ago       | yes          | not required  |
      | Weekly    | 7 days ago       | yes          | required      |

      | Always    |                  | no           | not required  |
      | Always    | 1 week ago       | no           | not required  |
      | Once      |                  | no           | not required  |
      | Once      | 1 week ago       | no           | not required  |
      | Weekly    |                  | no           | not required  |
      | Weekly    | 6 days ago       | no           | not required  |
      | Weekly    | 7 days ago       | no           | not required  |


