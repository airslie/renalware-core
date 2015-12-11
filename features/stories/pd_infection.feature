Feature: A Clinician records an infection for a patient caused by Peritoneal Dialysis(PD)

Background:
  Given that I'm logged in
    And there are ethnicities in the database
    And there are modality codes in the database
    And there are modality reasons in the database
    And there are edta causes of death in the database
    And there are episode types in the database
    And there are fluid descriptions in the database
    And some patients who need renal treatment
    And a patient has PD

@javascript
Scenario: Clinician records an episode of peritonitis
  When the Clinician records the episode of peritonitis
  Then the recorded episode should be displayed on PD info page

Scenario: Clinician views an episode of peritonitis
  Given a patient has episodes of peritonitis
  When a patient selects an episode of peritonitis view
  Then an episode of peritonitis can be viewed in more detail from the PD info page

@javascript
Scenario: Clinician updates an episode of peritonitis
  Given a patient has a recently recorded episode of peritonitis
  When the Clinician updates the episode of peritonitis
    And they add a medication to this episode of peritonitis
    And they record an organism and sensitivity to this episode of peritonitis
  Then the updated peritonitis episode should be displayed on PD info page
    And the new medication should be displayed on the updated peritonitis form
    And the recorded organism and sensitivity should be displayed on the updated peritonitis form
