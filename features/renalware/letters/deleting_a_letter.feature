Feature: Deleting a letter

  Until it is archived, a letter can be deleted.

  Background:
    Given Nathalie is a nurse
    And Doug is a doctor
    And Patty is a patient

  @web
  Scenario: A doctor deleted an un-archived letter
    Given Patty has a letter pending review
    Then Doug can delete Patty's letter
    And the letter is deleted

  @web
  Scenario: A user cannot delete an archived letter
    Given Patty has an approved letter
    Then Doug cannot delete Patty's letter
