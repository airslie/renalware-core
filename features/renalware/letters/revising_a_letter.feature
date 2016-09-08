Feature: Revising a letter

  In order to communicate information to the patient or other person, a letter
  is written and sent to the recipient(s).  A letter may be saved as a "draft"
  and later, revised with valuable information.

  A doctor may also revise a letter while reviewing it.

  Background:
    Given Nathalie is a nurse
    And Doug is a doctor
    And Patty is a patient

  @web
  Scenario: A nurse revised a letter
    Given Patty has a recorded letter
    Then Nathalie can revise Patty's letter

  @web
  Scenario: A doctor revised a letter pending review
    Given Patty has a letter pending review
    Then Doug can revise the letter
