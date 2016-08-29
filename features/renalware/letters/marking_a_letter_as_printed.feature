Feature: Marking a letter as printed

  A letter has to be printed so it can be mailed to the recipients.

  Business rules:

  - Only an approved letter can be marked as printed.
  - The letter is complete when printed.

  Background:
    Given Patty is a patient
    And Doug is Patty's doctor
    And Patty has an approved letter

  @web
  Scenario: A nurse marked a letter as printed
    Given Nathalie is a nurse
    When Nathalie marks the letter as printed
    Then the letter is completed
