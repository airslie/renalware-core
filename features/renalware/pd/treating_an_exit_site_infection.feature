Feature: Treating an exit site an infection

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web @javascript
  Scenario: A clinician treated an exit site infection
    When Clyde records an exit site infection for Patty
    And records the organism for the infection
    And records the medication for the infection
    Then an exit site infection is recorded for Patty

  @web @javascript
  Scenario: A clinician revised an exit site infection
    Given Patty is being treated for an exit site infection
    Then Clyde can revise the exist site infection

  @web @javascript
  Scenario: A clinician terminated an organism for an exit site infection
    Given Clyde recorded an exit site infection for Patty
    And recorded the organism for the infection
    Then Clyde can terminate the organism

  @web @javascript
  Scenario: A clinician terminated a medication for an exit site infection
    Given Clyde recorded an exit site infection for Patty
    And recorded the medication for the infection
    Then Clyde can terminate the medication
