Feature: A Doctor adds patient info on the patient's clinical summary page

Background:
  Given that I'm logged in 
    And there is a patient
    And they are on a patient's clinical summary
#wip
Scenario: Doctor adds an event
  #event also known as encounter
  When they add an event
    And complete the encounter form 
  Then they should see the new event on the clinical summary
#@wip
Scenario: Doctor adds a problem
  When they add a problem
    And complete the problem form
  Then they should see the new problem on the clinical summary
#@wip
Scenario: Doctor adds a medication
  When they add a medication
    And complete the medication form 
  Then they should see the new medication on the clinical summary
