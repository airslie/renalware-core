Feature: Archiving a letter

  A letter is archived when it has been "reviewed" by the doctor. An archived letter
  cannot be modified, and the content and visual presentation are stored permanently
  for legal purposes.

  An archived letter can be viewed in a browser and downloaded as a PDF.

  Background:
    Given Patty is a patient
    And Doug is Patty's doctor
    And Patty has a letter pending review

  @web
  Scenario: A doctor archived a letter
    When Doug archives the letter
    Then an archived copy of the letter is available
    And nobody can modify the letter
