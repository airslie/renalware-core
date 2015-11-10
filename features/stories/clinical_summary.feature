Feature: A Doctor adds patient info on the patient's clinical summary page

Background:
  Given that I'm logged in
    And there are ethnicities in the database
    And some patients who need renal treatment
    And they are on a patient's clinical summary

@javascript
Scenario: Doctor adds a problem
  Given they go to the problem list page
    When they add some problems to the list
  When they save the problem list
  Then they should see the new problems on the clinical summary

@javascript
Scenario: Doctor adds a medication for a patient
  Given there are drugs in the database
    And there are drug types in the database
    And existing drugs have been assigned drug types
    And there are medication routes in the database
  When they add a medication
    And complete the medication form by drug type select
    And complete the medication form by drug search
  Then should see the new medication on the patient's clinical summary
    And should see the new medication on their medications index.
