Feature: Determining which blood tests are required for a given patient.

  The blood test algorithm determines which tests are required for a patient by running the patient's data against a set of rules which say which tests are required given certain details of the patient.

  Background:
    Given there exist the following request algorithm rules:
      | id               | 1                        |
      | request          | vitamin B12 Serum        |
      | group            | Nephrology               |
      | param_type       | MedicationIncludesDrugId |
      | param_identifier | 1                        |
      | param_value      | nil                      |
      | frequency        | nil                      |

  Scenario: Determining based on whether or not a patient is on a certain medication.
    Given Patty is a patient
    When Clyde records the medication for Patty
    And the algorithm is ran for Patty in Nephrology
    Then The test should be required Patty

  Scenario: Determining based on whether or not a patient is on a certain medication.
    Given Patty is a patient
    And the algorithm is ran for Patty in Nephrology
    Then The test should not be required Patty
