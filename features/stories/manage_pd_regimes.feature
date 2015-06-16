Feature: A Clinician manages a patient's PD regimes

  Background:
    Given that I'm logged in
      And there are ethnicities in the database
      And there are modality codes in the database
      And there are PD bag types in the database
      And some patients who need renal treatment
      And a patient has PD

    Scenario: A clinician creates a new pd regime
      Given I choose to record a new pd regime
      When I complete the form for a pd regime
      Then I should see the new pd regime on the PD info page.

    Scenario: A clinician updates an existing pd regime
      Given a patient has existing PD Regimes
      When I choose to edit and update the form for a pd regime
      Then I should see the updated pd regime on the PD info page.

    Scenario: A clinician views an existing pd regime
      Given a patient has existing PD Regimes
      When I choose to view a pd regime
      Then I should see the chosen pd regime details

