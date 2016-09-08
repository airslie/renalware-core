Feature: Approving a letter

  A letter is approved when it has been "reviewed" by the doctor. An approved letter
  cannot be modified, and the content and visual presentation are stored permanently
  for legal purposes (archive).

  An approved letter can be viewed in a browser and downloaded as a PDF.

  A letter is considered electronically signed at the moment the user approves it.
  It can be signed by another doctor who is not assigned to the patient in the case
  the assigned doctor is absent (e.g. on vacation).

  Background:
    Given Patty is a patient
    And Patty has a letter pending review

  @web
  Scenario: A doctor approved a letter
    Given Doug is a doctor
    When Doug approves the letter
    Then an archived copy of the letter is available
    And nobody can modify the letter

  @web
  Scenario: A nurse archived a letter
    Given Nathalie is a nurse
    When Nathalie approves the letter
    Then the letter is signed by Nathalie
