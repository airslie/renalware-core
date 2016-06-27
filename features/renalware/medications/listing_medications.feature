Feature: Listing medications

  A user views the list of current and historical medications. Historical medications are those
  which were once prescribed to the patient but have since been terminated.

  Background:
    Given Clyde is a clinician
    And Patty is a patient
    And the date today is 07-06-2016

  @web
  Scenario: A clinician views the list of current medications
    Given Patty has medications:
      | drug_name              | dose   | frequency     | route_code | provider | terminated_on |
      | Acarbose Tablet        | 100 mg | bd            | PO         | Hospital |               |
      | Beta-Carotene Capsule  | 100mg  | bd            | SC         | GP       | 01-06-2016    |
      | Flucloxacillin Capsule | 50 mg  | bd for 7 days | PO         | GP       |               |
    When Clyde views the list of medications for Patty
    Then Clyde should see these current medications
      | drug_name              | dose   | frequency     | route_code | provider | terminated_on |
      | Acarbose Tablet        | 100 mg | bd            | PO         | Hospital |               |
      | Flucloxacillin Capsule | 50 mg  | bd for 7 days | PO         | GP       |               |
    And Clyde should see these historical medications
      | drug_name              | dose   | frequency     | route_code | provider | terminated_on |
      | Beta-Carotene Capsule  | 100mg  | bd            | SC         | GP       | 01-06-2016    |
