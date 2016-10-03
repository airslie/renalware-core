Feature: Adding a person in the directory

  The directory provides a global list of all people recorded in the application.
  The directory can be used in other modules such as Letters to select recipients for a letter.

  The directory does not currently include Patients or Primary Care Physicians,
  although we hope to integrate that in the future.

  Background:
    Given Clyde is a clinician

  @web
  Scenario: A clinician added a person
    When Clyde adds a person to the directory
    Then the directory includes the person

  @web
  Scenario: A clinician added an erroneous person
    When Clyde adds an erroneous person to the directory
    Then the person is not accepted

  @web
  Scenario: A clinician updated a person
    Given A person exists in the directory
    Then Clyde can update the person
