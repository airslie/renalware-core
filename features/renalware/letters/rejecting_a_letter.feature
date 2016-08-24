Feature: Rejecting a letter

  After reviewing a letter, a doctor may decide that the letter
  is missing some important details that cannot be included at that time by just
  editing the letter.  The doctor may therefore reject the letter so it can be revised later.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Doug is Patty's doctor

  Scenario: A doctor rejected a letter pending review
    Given Patty has a letter pending review
    Then Doug can reject the letter
