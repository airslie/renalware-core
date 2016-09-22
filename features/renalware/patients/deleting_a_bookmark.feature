Feature: Bookmarking a patient

   A user removes a patient from their bookmarks they no longer require quick access to.

  @web @javascript
  Scenario: A user deletes a bookmark
    Given Clyde is a clinician
    And Clyde has the following patients bookmarked:
      | Patty    |
      | Don      |
      | Yossef   |
    When Clyde deletes the bookmark for Don
    Then Clyde has the following patient bookmarks:
      | patient  | notes  | urgent |
      | Patty    |        | false  |
      | Yossef   |        | false  |
