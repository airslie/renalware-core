Feature: A Clinician records an infection for a patient caused by Peritoneal Dialysis(PD)

Background:
  Given that I'm logged in
    And there are ethnicities in the database
    And there are modalities in the database
    And there are modality reasons in the database
    And there are edta causes of death in the database 
    And I have a patient in the database
@wip
Scenario: Clinician records an episode of peritonitis
  Given a patient has PD
  When the Clinician records the episode of peritonitis
  Then the recorded episode should be displayed on PD info page
@wip
Scenario: Clinician updates an episode of peritonitis
  Given a patient has PD
    And a patient has a recently recorded episode of peritonitis 
  When the Clinician updates the episode of peritonitis
  Then the updated episode should be displayed on PD info page 
@wip
Scenario: Clinician records an exit site infection
  Given a patient has PD
  When the Clinician records an exit site infection
  Then the recorded exit site infection should be displayed on PD info page 





