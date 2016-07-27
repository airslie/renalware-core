Feature: Revising a prescription

  When a user revises a patient's prescription to a drug, the existing prescription will be
  terminated and a new one will be created with the revised values.

  Background:
    Given Clyde is a clinician
    And Patty is a patient
    And the date today is 12-10-2016

  @web @javascript
  Scenario: A clinician revises a prescription for a patient
    Given Patty has the following prescriptions:
      | drug_name       | dose          | frequency | route_code | provider | terminated_on |
      | Acarbose Tablet | 100 milligram | bd        | PO         | Hospital |               |
    When Clyde revises the prescription for Patty with these changes:
      | dose   | 200 milligram |
    Then Patty should have the following prescriptions:
      | drug_name       | dose          | frequency | route_code | provider | terminated_on |
      | Acarbose Tablet | 200 milligram | bd        | PO         | Hospital |               |
      | Acarbose Tablet | 100 milligram | bd        | PO         | Hospital | 12-10-2016    |
