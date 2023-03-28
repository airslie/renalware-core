Feature: Writing a clinical letter

  To officially inform the patient and/or other interested parties about
  some clinical aspect of the patient, an author writes a letter.

  A Clinical Letter is identical to a Clinic Visit Letter except that is does not reference or
  link to an specific Clinic Visit.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Doug is a doctor
    And Patty has a practice
    And Patty has recorded problems with notes
    And Patty has completed pathology investigations relevant to the clinic letter

  @web @javascript
  Scenario: A doctor drafted a clinical letter
    When Doug drafts a clinical letter for Patty
    Then a clinical letter is drafted for Patty
    And the clinical letter lists Patty's problems and notes
    And the clinical letter lists Patty's recent pathology results
