Feature: Reviewing a patient's clinical summary

  A doctor reviews a clinical summary periodically to gain an understanding of
  the current status of a patient.

  TODO
  - migrate displaying current events from legacy acceptance test "Recording patient events"

  Background:
    Given Patty is a patient
    And Donna is a doctor
    And Donna is logged in
    And the date today is 07-06-2016

  Scenario:
    Given Patty has the following prescriptions:
      | drug_name              | dose          | frequency     | route_code | provider | terminated_on |
      | Acarbose Tablet        | 100 milligram | bd            | PO         | Hospital |               |
      | Beta-Carotene Capsule  | 100 milligram | bd            | SC         | GP       | 01-06-2016    |
      | Flucloxacillin Capsule | 50 milligram  | bd for 7 days | PO         | GP       |               |
    And Patty has problems:
      | description                                 | recorded_on | terminated_on |
      | Cutaneous hepatic porphyria                 | 01-05-2016  |               |
      | Type II diabetes mellitus with complication | 02-05-2016  |               |
      | Carotenemia                                 | 03-05-2016  | 06-06-2016    |
    When Donna reviews Patty's clinical summary
    Then Donna should see these current prescriptions in the clinical summary
      | drug_name              | dose   | frequency     | route_code | provider | terminated_on |
      | Acarbose Tablet        | 100 mg | bd            | PO         | Hospital |               |
      | Flucloxacillin Capsule | 50 mg  | bd for 7 days | PO         | GP       |               |
    And Donna should see these current problems in the clinical summary:
      | description                                 | recorded_on |
      | Cutaneous hepatic porphyria                 | 01-05-2016  |
      | Type II diabetes mellitus with complication | 02-05-2016  |
