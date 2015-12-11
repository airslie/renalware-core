Feature: Recording a medication

Background:
  Given that I'm logged in
    And there are ethnicities in the database
    And some patients who need renal treatment
    And they are on a patient's clinical summary

@javascript
Scenario: Doctor adds a medication for a patient
  When they add a medication
    And complete the medication form by drug type select
    And complete the medication form by drug search
  Then should see the new medication on the patient's clinical summary
    And should see the new medication on their medications index.
