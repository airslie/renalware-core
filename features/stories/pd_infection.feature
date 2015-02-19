Feature: A Clinician records an infection for a patient caused by Peritoneal Dialysis(PD)

Background:
  Given that I'm logged in
    And there are ethnicities in the database
    And there are modalities in the database
    And there are modality reasons in the database
    And there are edta causes of death in the database 
    And I have a patient in the database

Scenario: Clinician records an episode of peritonitis
  Given a patient has PD
    And they have been diagnosed with peritonitis
  When the Clinician records the episode of peritonitis
  Then the episode should be displayed on PD info page  



