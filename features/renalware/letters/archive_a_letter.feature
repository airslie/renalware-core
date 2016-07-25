@wip
Feature: Archiving a letter

  A letter is considered archived when is has been "reviewed" by the doctor.
  When archived, a letter can no longer be edited, and will visually stay intact for years
  to come for legal purposes.

  An archived letter can be viewed in a browser and downloaded as PDF.

  Background:
    Given Patty is a patient
    And Doug is Patty's doctor

  Scenario: A doctor archived a letter
    Given Patty has a typed letter
    When Doug archives the letter
    Then An archived copy of the letter is available
    And nobody can modify the letter
