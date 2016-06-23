Feature: Bookmarking a patient

   A user removes a patient from their bookmarks they no longer require quick access to.

  @web @javascript
  Scenario: A user deletes a bookmark
    Given Clyde is a clinician
    And Clyde has the following patients bookmarked:
      | Ibiere Elliott     |
      | Rochelle Hinsberry |
      | Wendy Sears        |
    When Clyde deletes the bookmark for Wendy Sears
    Then the following patients appear in Clyde's bookmarked patient list:
      | Ibiere Elliott     |
      | Rochelle Hinsberry |
