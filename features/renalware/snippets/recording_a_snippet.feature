Feature: A clinician creates a snippet

  A snippet is a reusable piece of text with a title and body
  that can inserted into a letter or event.

  Background:
    And Clyde is a clinician
    And Clyde is logged in

  @web @wip
  Scenario: A clinician recorded a new snippet
    When Clyde records a new snippet
      | title | body |
      | Nephrology Clinic DNA | This lady did not attend the Nephrology Clinic today  |
    Then Clyde has these snippets
      | title | body |
      | Nephrology Clinic DNA | This lady did not attend the Nephrology Clinic today  |
