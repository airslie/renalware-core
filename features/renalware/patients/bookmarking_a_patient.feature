Feature: Bookmarking a patient

  A logged in user bookmarks a patient and sees that patient in their dashboard. This can be used to
  remind the user of certain patients that need special attention.

  Rules:
  - The user can optional specify notes against the bookmark to remind themselves why its there.
  - The user can mark the bookmark as Urgent so that it can catch their attention
    more readily when displayed.

  @web @javascript
  Scenario: A user bookmarks a patient
    Given Clyde is a clinician
    And the following patients:
      | Patty    |
      | Don      |
      | Yossef   |
    When Clyde bookmarks Patty with the note "Lorem ipum delor" and indicates it is urgent
    And Clyde bookmarks Yossef with the note "" and indicates it is not urgent
    Then Clyde has the following patient bookmarks:
      | Patient  | Notes            | Urgent |
      | Patty    | Lorem ipum delor | true   |
      | Yossef   |                  | false  |
