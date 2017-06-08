Feature: A Clinician manages add a PD regime to a patient

  Background:
    Given Clyde is a clinician
      And Patty is a patient
      And Patty has the PD modality

  @web @javascript
  Scenario: A clinician added a first regime to Patty
    Given Patty has no PD regimes
    When Clyde adds a CAPD regime
    Then the CAPD becomes the current one
