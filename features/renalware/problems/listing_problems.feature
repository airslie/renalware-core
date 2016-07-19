Feature: Listing problems

  A user views the list of current and archived problems. Archived problems are those
  which were created for the patient but have since been terminated.

  Background:
    Given Clyde is a clinician
    And Patty is a patient
    And the date today is 07-06-2016

  @web
  Scenario: A clinician views the list of current and historical problems
    Given Patty has problems:
      | description                                 | recorded_on | terminated_on |
      | Cutaneous hepatic porphyria                 | 01-05-2016  |               |
      | Type II diabetes mellitus with complication | 02-05-2016  |               |
      | Carotenemia                                 | 03-05-2016  | 06-06-2016    |
    When Clyde views the list of problems for Patty
    Then Clyde should see these current problems:
      | description                                 | recorded_on |
      | Cutaneous hepatic porphyria                 | 01-05-2016  |
      | Type II diabetes mellitus with complication | 02-05-2016  |
    And Clyde should see these archived problems:
      | description                                 | recorded_on | terminated_on |
      | Carotenemia                                 | 03-05-2016  | 06-06-2016    |
