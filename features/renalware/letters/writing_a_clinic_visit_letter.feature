Feature: Writing a clinic visit letter

  To officially inform the patient and/or other interested parties about
  the outcome of a visit to a clinic, an author writes a letter.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Doug is Patty's doctor
    And Patty has a clinic visit
    And Patty has current medications

  @web @wip
  Scenario: A doctor drafted a clinic visit letter
    When Doug drafts a clinic letter for Patty
    Then a letter for Patty's clinical visit is drafted
    And the letter lists Patty's current medications

  @web
  Scenario: A doctor revised a clinic visit letter
    Given a letter for Patty's clinical visit was drafted
    Then Doug can revise Patty's clinic visit letter

  @web
  Scenario: A doctor drafted an erroneous clinic visit letter
    When Doug drafts an erroneous clinic visit letter
    Then the letter is not drafted
