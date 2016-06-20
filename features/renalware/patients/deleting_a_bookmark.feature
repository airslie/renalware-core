Feature: Bookmarking a patient

  A logged in user who has a patient under their bookmarks views the patient summary and deletes
  the bookmark.

  @web @javascript
  Scenario: A user deletes a bookmark
    Given Clyde is a clinician
    And the following patients:
      | Ibiere Elliott     |
      | Rochelle Hinsberry |
      | Wendy Sears        |
    And Clyde has the following patients bookmarked:
      | Ibiere Elliott     |
      | Rochelle Hinsberry |
      | Wendy Sears        |
    When Clyde deletes the bookmark for Wendy Sears
    Then the following patients appear in Clyde's bookmarked patient list:
      | Ibiere Elliott     |
      | Rochelle Hinsberry |
