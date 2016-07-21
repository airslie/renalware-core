Feature: Updating a prescription

  When a user updates a patient's prescription to a drug, the existing prescription will be
  terminated and a new one will be created with the updated values.

  Background:
    Given Clyde is a clinician
    And Patty is a patient
    And the date today is 12-10-2016

  @web @javascript
  Scenario: A clinician updates a prescription for a patient
    Given Patty has the following prescriptions:
      | drug_name              | dose   | frequency     | route_code | provider | terminated_on |
      | Acarbose Tablet        | 100 mg | bd            | PO         | Hospital |               |
    When Clyde updates the prescription for Patty with these changes:
      | dose   | 200 mg |
    Then Patty should have the following prescriptions:
      | drug_name              | dose   | frequency     | route_code | provider | terminated_on |
      | Acarbose Tablet        | 200 mg | bd            | PO         | Hospital |               |
      | Acarbose Tablet        | 100 mg | bd            | PO         | Hospital | 12-10-2016    |
