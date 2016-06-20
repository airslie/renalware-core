Feature: Bookmarking a patient

  A logged in user bookmarks a patient and sees that patient in their dashboard. This can be used to
  remind the user of certain patients that need special attention.

  Scenario:
    Given Clyde is a clinician
    And the following patients:
      | Ibiere Elliott     |
      | Rochelle Hinsberry |
      | Wendy Sears        |
    When Clyde bookmarks Ibiere Elliott
    And Clyde bookmarks Rochelle Hinsberry
    Then the following patients appear in Clyde's bookmarked patient list:
      | Ibiere Elliott     |
      | Rochelle Hinsberry |
