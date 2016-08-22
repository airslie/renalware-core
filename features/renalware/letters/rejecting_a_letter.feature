Feature: Rejecting a letter

  Given a letter is pending for review, a Doctor can reject the letter
  because it is missing some information.  The letter is then put
  back in state "Draft".

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Doug is Patty's doctor

  Scenario: A doctor rejected a letter pending review
    Given Patty has a letter pending review
    Then Doug can reject the letter
