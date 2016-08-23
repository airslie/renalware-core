@wip
Feature: Archiving a letter

  A letter is archived when it has been "reviewed" by the doctor. An archived letter
  cannot be modified, and the content and visual presentation are stored permanently
  for legal purposes.

  An archived letter can be viewed in a browser and downloaded as a PDF.

  A letter is considered electronically signed at the moment it is being archived.

  Background:
    Given Patty is a patient
    And Doug is Patty's doctor
    And Patty has a letter pending review

  @web
  Scenario: A doctor archived a letter
    When Doug archives the letter
    Then an archived copy of the letter is available
    And nobody can modify the letter

  @web
  Scenario: A nurse archived a letter
    Given Nathalie is a nurse
    When Nathalie archives the letter
    And the letter is signed by Nathalie
