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
    When Clyde bookmarks Patty with the note "Arrange cardiology OP appt ASAP!" and indicates it is urgent
    And Clyde bookmarks Yossef
    Then Clyde has the following patient bookmarks:
      | patient  | notes                            | urgent |
      | Patty    | Arrange cardiology OP appt ASAP! | true   |
      | Yossef   |                                  | false  |
