Feature: Determine tests based on patient rules

  The patient pathology algorithm checks if there are any patient_rules which apply and lists the required tests accordingly.

  The patient_rules tables contains rules which are specific to a patient and will be printed in the form under a separate section. These are rules for tests are defined by the clinician in a text field "test_description".

  Its possible the clinician may define a patient specific test which has already been determined as required by the global rules algorithm, in which case its up to the clinician to decide what to do.

  Scenario Outline:

    Given Patty is a patient
    And Patty has a patient rule:
      | id                    | 1                   |
      | lab                   | Biochem             |
      | test_description      | Test for antibodies |
      | sample_number_bottles | 1                   |
      | sample_type           | ...                 |
      | frequency             | <frequency>         |
      | patient_id            | 1                   |
      | last_tested_at        | <last_tested_at>    |
    And the current date is within the patient rule's start/end date range <within_range>
    When the patient pathology algorithm is ran for Patty
    Then the required pathology should includes the test <test_required>

    Examples:
      | frequency | last_tested_at | within_range | test_required |
      | Always    | nil            | yes          | yes           |
      | Always    | 1 week ago     | yes          | yes           |
      | Once      | nil            | yes          | yes           |
      | Once      | 1 week ago     | yes          | no            |
      | Weekly    | nil            | yes          | yes           |
      | Weekly    | 6 days ago     | yes          | no            |
      | Weekly    | 7 days ago     | yes          | yes           |

      | Always    | nil            | no           | no            |
      | Always    | 1 week ago     | no           | no            |
      | Once      | nil            | no           | no            |
      | Once      | 1 week ago     | no           | no            |
      | Weekly    | nil            | no           | no            |
      | Weekly    | 6 days ago     | no           | no            |
      | Weekly    | 7 days ago     | no           | no            |


