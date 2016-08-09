Feature: Determining tests required based on patient's prescriptions

  An observation may be required depending on whether or not the patient is currently being
  prescribed a drug.

  Background:
    Given the global rule sets:
      | request_description_code     | BFF        |
      | clinic                       | Access     |
      | frequency_type               | Always     |
    And the rule set contains these rules:
      | type             | id                   | operator | value |
      | PrescriptionDrug | Cefuroxime Injection |          |       |
    And Patty is a patient

  Scenario: The algorithm determines a test to be required for the patient
    Given Patty has the following prescriptions:
      | drug_name            | dose          | frequency | route_code | provider | terminated_on |
      | Cefuroxime Injection | 100 milligram | bd        | PO         | Hospital |               |
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is required

  Scenario: The algorithm determines a test to be not required for the patient
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is not required
