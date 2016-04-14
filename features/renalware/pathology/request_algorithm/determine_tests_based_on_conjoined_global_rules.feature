Feature: Determine tests based on conjoined global rules

  The global pathology algorithm checks if there are any rules which apply to the patient and lists the required tests accordingly. For any rules which apply to the patient, it also checks if it has a conjoined rule - a second rule which is also required to pass for the patient in order for the test to be required.

  A conjoined rule can be though of as a "if rule #1 is true and rule #2 is true, then the test is required for the patient.".

  The conjoined_global_rules table contains two rule_id's and also a frequency. So the frequency used by the algorithm comes from the "conjoined_global_rules.frequency" column rather than what is set on "rules.frequency" for either of the two rules.

  Background:
    Given there exist the following request algorithm global rules:
      | id               | 3                   | 4                 |
      | request          | vitamin B12 Serum   | vitamin B12 Serum |
      | group            | Nephrology          | Nephrology        |
      | param_type       | ObservationResultLT | ModalityIs        |
      | param_identifier | 429                 | HD_home           |
      | param_value      | 100                 | nil               |
      | frequency        | Once                | Always            |
    And there exist the following request algorithm global rule conjunctions:
      | id        | 1      |
      | rule_id_1 | 3      |
      | rule_id_2 | 4      |
      | frequency | Weekly |

  Scenario Outline:

    Given Patty is a patient
    And Patty has an observation result value of <observation_result>
    And Patty has an modality of <modality>
    When the global pathology algorithm is ran for Patty
    Then the required pathology should includes the test <test_required>

  Examples:
    | observation_result | modality   | test_required |
    | 99                 | HD_home    | yes           |
    | 100                | HD_home    | no            |
    | 99                 | nephrology | yes           |
    | 100                | nephrology | yes           |
