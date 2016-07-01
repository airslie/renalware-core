Feature: Determining observations required based on patient's drug types

  An observation may be required depending on whether or not the patient is currently being
  medication with a drug of a specified drug_type.

  Scenario: The algorithm determines a test to be required for the patient
    Given the global rule sets:
      | request_description_code     | BFF        |
      | clinic                       | Access     |
      | frequency_type               | Always     |
    And the rule set contains these rules:
      | type     | id  | operator | value |
      | DrugType | ESA |          |       |
    And Patty is a patient
    And Patty has medications:
      | drug_name    | dose   | frequency | route_code | provider | terminated_on |
      | Epoetin Beta | 100 mg | bd        | PO         | Hospital |               |
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is required
