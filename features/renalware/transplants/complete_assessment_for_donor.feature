Feature: Complete the donor assessment

  A potential living kidney donor needs a series of tests to assess and document their suitability
  to have a kidney removed and to be a donor.

  Background:
    Given Clyde is a clinician
    And Don is a donor in the system

  @web
  Scenario: Create an assessment
    When Clyde creates a donor workup for Don
    Then Don's donor workup exists

  @web
  Scenario: Update an assessment
    Given Don has a donor workup
    When Clyde updates the donor assessment
    Then Don's donor workup gets updated