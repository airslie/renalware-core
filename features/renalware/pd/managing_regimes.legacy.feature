Feature: A Clinician manages a patient's PD regimes

  Background:
    Given that I'm logged in
      And there are modality codes in the database
      And there are PD bag types in the database
      And some patients who need renal treatment
      And a patient has PD

    #CAPD Regime
    Scenario: A clinician creates a new capd regime
      Given I choose to record a new capd regime
      When I complete the form for a capd regime
      Then I should see the new capd regime on the PD info page
        And the new capd regime should be current

    Scenario: A clinician updates an existing capd regime
      Given a patient has existing CAPD Regimes
      When I choose to edit and update the form for a capd regime
      Then I should see the updated capd regime on the PD info page

    Scenario: A clinician views an existing capd regime
      Given a patient has existing CAPD Regimes
      When I choose to view a capd regime
      Then I should see the chosen capd regime details

    #APD Regime
    Scenario: A clinician creates a new apd regime
      Given I choose to record a new apd regime
      When I complete the form for a apd regime
      Then I should see the new apd regime on the PD info page
        And the new apd regime should be current

    Scenario: A clinician updates an existing apd regime
      Given a patient has existing APD Regimes
      When I choose to edit and update the form for a apd regime
      Then I should see the updated apd regime on the PD info page

    Scenario: A clinician views an existing apd regime
      Given a patient has existing APD Regimes
      When I choose to view a apd regime
      Then I should see the chosen apd regime details
