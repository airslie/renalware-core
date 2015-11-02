@wip
Feature: Record the transplant registration for a patient

  A patient requires the transplant of one or many organs: kidney, pancreas or liver. To
  receive a transplant a patient needs to be registered on a wait list.

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web
  Scenario: Register a patient on the transplant wait list
    When Clyde registers Patty on the wait list with status "Active" starting on "24-10-2015"
    Then Patty has an active transplant registration since "24-10-2015"

  @web
  Scenario: Update the transplant wait list registration
    Given Patty is registered on the wait list
    Then Clyde can update Patty's transplant registration
