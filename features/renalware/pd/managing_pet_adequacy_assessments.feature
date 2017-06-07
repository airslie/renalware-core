Feature: A Clinician creates a PET/Adequacy form

  The form is periodically completed in order to capture data required for the
  National Renal Data Set (NRD).

  Background:
    Given Clyde is a clinician
      And Patty is a patient
      And Patty has the PD modality

  @web
  Scenario: A clinician created a PET/Adequacy record for a patient
    When Clyde creates a PET Adequacy for Patty
    Then Patty has a PET Adequacy
