Feature: An admin manages the bag types list

  Background:
    Given that I'm logged in
      And there are ethnicities in the database
      And there are modalities in the database
      And some patients who need renal treatment
      And a patient has PD

    Scenario: A clinician creates a new pd regime
      Given I choose to record a new pd regime
      When I complete the form for a pd regime
      Then I should see the new pd regime on the PD info page.

    Scenario: A clinician updates an existing pd regime
      Given there are existing PD Regimes
      When I choose to edit and update the form for a pd regime
      Then I should see the updated pd regime on the PD info page.

