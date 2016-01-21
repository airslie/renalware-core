Feature: Treating a peritonitis episode

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web @javascript
  Scenario: A clinician treated a peritonitis episode
    When Clyde records a peritonitis episode for Patty
    And records the organism for the episode
    And records the medication for the episode
    Then a peritonitis episode is recorded for Patty

  @web @javascript
  Scenario: A clinician revised a peritonitis episode
    Given Patty is being treated for a peritonitis episode
    Then Clyde can revise the peritonitis episode

  @web @javascript
  Scenario: A clinician terminated an organism for a peritonitis episode
    Given Clyde recorded a peritonitis episode for Patty
    And recorded the organism for the episode
    Then Clyde can terminate the organism for the episode

  @web @javascript
  Scenario: A clinician terminated a medication for a peritonitis episode
    Given Clyde recorded a peritonitis episode for Patty
    And recorded the medication for the episode
    Then Clyde can terminate the medication for the episode
