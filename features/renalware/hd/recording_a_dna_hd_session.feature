Feature: Recording an HD DNA session

  A nurse records a Did Not Attend (DNA) session if the patient did not show.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Patty has the HD modality

  @web
  Scenario: A nurse recorded a DNA session
    When Nathalie records a DNA HD session for Patty with the notes "Possibly on holiday"
    Then Patty has a new NDA HD session
