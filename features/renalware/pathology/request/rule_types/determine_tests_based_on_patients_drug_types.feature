Feature: Determining observations required based on patient's drug types

  An observation may be required depending on whether or not the patient is currently
  prescribed a drug of a specified drug_type.

  Scenario: The algorithm determines a test to be required for the patient
    Given the global rule sets:
      | request_description_code     | BFF        |
      | clinic                       | Access     |
      | frequency_type               | Always     |
    And the rule set contains these rules:
      | type                 | id  | operator | value |
      | PrescriptionDrugType | ESA |          |       |
    And Patty is a patient
    And Patty has the following prescriptions:
      | drug_name    | dose          | frequency | route_name | provider | terminated_on |
      | Epoetin Beta | 100 milligram | bd        | PO         | Hospital |               |
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is required

  Scenario: The algorithm determines a test to be required for the patient with future terminated drugs
    Given the global rule sets:
      | request_description_code     | BFF        |
      | clinic                       | Access     |
      | frequency_type               | Always     |
    And the rule set contains these rules:
      | type                 | id  | operator | value |
      | PrescriptionDrugType | ESA |          |       |
    And Patty is a patient
    And the date today is 07-06-2016
    And Patty has the following prescriptions:
      | drug_name    | dose          | frequency | route_name | provider | terminated_on |
      | Epoetin Beta | 100 milligram | bd        | PO         | Hospital | 01-01-2020 |
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is required

Scenario: The algorithm determines a test to be required for the patient with past terminated drugs
    Given the global rule sets:
      | request_description_code     | BFF        |
      | clinic                       | Access     |
      | frequency_type               | Always     |
    And the rule set contains these rules:
      | type                 | id  | operator | value |
      | PrescriptionDrugType | ESA |          |       |
    And Patty is a patient
    And the date today is 07-06-2016
    And Patty has the following prescriptions:
      | drug_name    | dose          | frequency | route_name | provider | terminated_on |
      | Epoetin Beta | 100 milligram | bd        | PO         | Hospital | |
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is required
