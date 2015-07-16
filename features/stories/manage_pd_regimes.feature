Feature: A Clinician manages a patient's PD regimes

  Background:
    Given that I'm logged in
      And there are ethnicities in the database
      And there are modality codes in the database
      And there are PD bag types in the database
      And some patients who need renal treatment
      And a patient has PD

    Scenario: A clinician creates a new capd regime
      Given I choose to record a new capd regime
      When I complete the form for a capd regime
      Then I should see the new capd regime on the PD info page.
      And the new capd regime should be current

    Scenario: A clinician updates an existing capd regime
      Given a patient has existing CAPD Regimes
      When I choose to edit and update the form for a pd regime
      Then I should see the updated capd regime on the PD info page.

    Scenario: A clinician views an existing capd regime
      Given a patient has existing CAPD Regimes
      When I choose to view a capd regime
      Then I should see the chosen capd regime details

