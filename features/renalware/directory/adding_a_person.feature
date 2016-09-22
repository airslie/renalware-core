@wip
Feature: Adding a person in the directory

  Users can add people to the global directory.  This allow using the person's
  name and address in different areas of the application, such as letters.

  Background:
    Given Clyde is a clinician

  @web
  Scenario: A clinician added a person
    When Clyde adds a person to the directory
    Then the directory contains 1 person

  @web
  Scenario: A clinician added an erroneous person
    When Clyde adds an erroneous person to the directory
    Then the person is not accepted

  @web
  Scenario: A clinician updated a person
    Given A person exists in the directory
    Then Clyde can update the person
