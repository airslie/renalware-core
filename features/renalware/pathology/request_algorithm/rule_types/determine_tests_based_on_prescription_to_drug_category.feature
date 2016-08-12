Feature: Determining tests required based on patient's prescription to a drug category

  An observation may be required depending on whether or not the patient is currently
  prescribed a drug with the category Alucaps which could be one of the following drugs:

    Aluminium Hydroxide Capsule
    Aluminium Hydroxide Mixture

  Background:
    Given the drugs with the drug_category Alucaps:
      | id  | name                        |
      | 102 | Aluminium Hydroxide Capsule |
      | 103 | Aluminium Hydroxide Mixture |
    And the global rule sets:
      | request_description_code     | BFF        |
      | clinic                       | Access     |
      | frequency_type               | Always     |
    And the rule set contains these rules:
      | type                     | id      | operator | value |
      | PrescriptionDrugCategory | Alucaps |          |       |
    And Patty is a patient

  Scenario: The rule is required because patty is being prescribed Aluminium Hydroxide Capsule
    Given Patty is being prescribed Aluminium Hydroxide Capsule
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is required

  Scenario: The rule is required because patty is being prescribed Aluminium Hydroxide Mixture
    Given Patty is being prescribed Aluminium Hydroxide Mixture
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is required

  Scenario: The rule is not required
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is not required
