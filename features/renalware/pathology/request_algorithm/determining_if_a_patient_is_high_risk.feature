Feature: Determining if a patient is high risk

  When conducting pathology observations, certain patients will be deemed high risk so their
  blood samples need to be handled with extra care.

  A patient is determined to be high risk based on a set of rules using the same rule types as the
  global algorithm does.

  Background:
    Given Patty is a patient
    And the high risk rule set contains these rules:
      | type              | id  | operator | value    |
      | ObservationResult | HIV | ==       | positive |

  Scenario: The patient was determined to be high risk
    Given Patty has observed an HIV value of positive
    When the high risk algorithm is run for Patty
    Then Patty is determined to be high risk

  Scenario: The patient was determined not to be high risk
    Given Patty has observed an HIV value of negative
    When the high risk algorithm is run for Patty
    Then Patty is determined not to be high risk
