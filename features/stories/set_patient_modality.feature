Feature: A Clinician sets the modality for a patient

Background:
  Given that I'm logged in
    And there are ethnicities in the database
    And there are modality codes in the database
    And there are modality reasons in the database
    And there are edta causes of death in the database
    And some patients who need renal treatment

Scenario: Clinician sets the modality for a patient with no current modality

Scenario: Clinician sets the modality for a patient with an existing modality

