Feature: Listing prescriptions

  A user views the list of current and historical prescriptions. Historical prescriptions
  include both current and terminated prescriptions.

  Background:
    Given Clyde is a clinician
    And Patty is a patient
    And the date today is 07-06-2016

  @web @wip
  Scenario: A clinician views the list of current prescriptions
    Given Patty has the following prescriptions:
      | drug_name              | dose          | frequency     | route_code | provider | terminated_on |
      | Acarbose Tablet        | 100 milligram | bd            | PO         | Hospital |               |
      | Beta-Carotene Capsule  | 100 milligram | bd            | SC         | GP       | 01-06-2016    |
      | Flucloxacillin Capsule | 50 milligram  | bd for 7 days | PO         | GP       |               |
    When Clyde views the list of prescriptions for Patty
    Then Clyde should see these current prescriptions
      | drug_name              | dose   | frequency     | route_code | provider | terminated_on |
      | Acarbose Tablet        | 100 mg | bd            | PO         | Hospital |               |
      | Flucloxacillin Capsule | 50 mg  | bd for 7 days | PO         | GP       |               |
    And Clyde should see these historical prescriptions
      | drug_name              | dose   | frequency     | route_code | provider | terminated_on |
      | Acarbose Tablet        | 100 mg | bd            | PO         | Hospital |               |
      | Beta-Carotene Capsule  | 100 mg | bd            | SC         | GP       | 01-06-2016    |
      | Flucloxacillin Capsule | 50 mg  | bd for 7 days | PO         | GP       |               |

