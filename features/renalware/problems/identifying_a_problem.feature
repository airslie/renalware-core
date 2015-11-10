Feature: Identifying a problem

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
