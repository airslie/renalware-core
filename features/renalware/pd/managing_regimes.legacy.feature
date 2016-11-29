Feature: A Clinician manages a patient's PD regimes

  Background:
    Given that I'm logged in
      And some patients who need renal treatment
      And a patient has PD

    # CAPD Regimes
    Scenario: A clinician creates a new CAPD regime
      Given I choose to record a new CAPD regime
      When I complete the form for a CAPD regime
      Then I should see the new CAPD regime on the PD dashboard
        And the new CAPD regime should be current

    @wip @web
    Scenario: A clinician creates a new CAPD regime to succeed the previous one
      Given Patty is a patient
        And Clyde is a clinician
        And Patty has an existing CAPD regime
       When Clyde create a new CAPD regime
       Then the new CAPD regime is current
        And Clyde cannot edit the old regime

    Scenario: A clinician updates an existing CAPD regime
      Given a patient has existing CAPD regimes
      When I choose to edit and update the form for a CAPD regime
      Then I should see the updated CAPD regime on the PD dashboard

    Scenario: A clinician views an existing CAPD regime
      Given a patient has existing CAPD regimes
      When I choose to view a CAPD regime
      Then I should see the chosen CAPD regime details

    # APD Regimes
    Scenario: A clinician creates a new APD regime
      Given I choose to record a new APD regime
      When I complete the form for a APD regime
      Then I should see the new APD regime on the PD dashboard
        And the new APD regime should be current

    Scenario: A clinician updates an existing APD regime
      Given a patient has existing APD regimes
      When I choose to edit and update the form for a APD regime
      Then I should see the updated APD regime on the PD dashboard

    Scenario: A clinician views an existing APD regime
      Given a patient has existing APD regimes
      When I choose to view a APD regime
      Then I should see the chosen APD regime details

#     Scenario:
# Given a patient has an existing PD regime
# When I create a new regime
# The end date of the old regime (APD or CAPD) should be set to the start date of the new regime
# And I should not be able to alter the old regime
