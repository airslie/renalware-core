@wip
Feature: Treating a peritonitis episode

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web @javascript
  Scenario: A clinician treated a peritonitis episode
    When Clyde records a peritonitis episode for Patty
    And records the organism for the episode
    And records the medication for the episode
    Then an exit site infection is recorded for Patty
