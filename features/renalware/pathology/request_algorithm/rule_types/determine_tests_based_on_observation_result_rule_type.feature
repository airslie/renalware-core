Feature: Determine tests based on observation result rule type

  A rule with rule_type "ObservationResultLT" should determine the test to be required for the patient if an observation result with observation.description_id = rule.param_identifier and observation.result < rule.param_value exists for that patient.

  Otherwise if observation.result >= rule.param_value then the test should not be required for the patient.

  Background:
    Given there exist the following request algorithm global rules:
      | id               | 1                   |
      | request          | vitamin B12 Serum   |
      | group            | Nephrology          |
      | param_type       | ObservationResultLT |
      | param_identifier | 429                 |
      | param_value      | <param_value>       |
      | frequency        | Once                |

  Scenario Outline:

    Given Patty is a patient
    And Clyde is a clinician
    And Patty has an observation result value of <observation_result>
    When Clyde prints the blood test request form for Patty
    Then the blood test form includes the test <test_required>

  Examples:

    | observation_result | param_value | test_required |
    | 99                 | 100         | yes           |
    | 100                | 100         | no            |

