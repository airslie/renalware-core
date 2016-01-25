Feature: Recording a medication

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @wip
  Scenario: Doctor recorded the medication for a patient
    When Clyde records the medication for Patty
    Then the medication is recorded for Patty

  @javascript @wip @legacy
  Scenario: Doctor adds a medication for a patient
    Given that I'm logged in
      And there are ethnicities in the database
      And some patients who need renal treatment
      And they are on a patient's clinical summary
    When they add a medication
      And complete the medication form by drug type select
      And complete the medication form by drug search
    Then should see the new medication on the patient's clinical summary
      And should see the new medication on their medications index.
