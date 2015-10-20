@wip
Feature: Record the transplant required by a patient

  A patient may require the transplant of one or many organs: kidney, pancreas or liver.
  When a transplant is recorded, the patient enters the wait list for organ(s).
  The transplant form captures details used for matching a donor with the patient.

  Transplant details:

  - Type of transplant patient requires
  - Pancreas only transplant type
  - Rejection Risk
  - Blood Group
  - HLA Type
  - If kidney/pancreas required, is the patient also to be listed for kidney only?
  - In addition to this registration, is the patient to be listed for other organ(s)?
  - Has this recipient received a previous kidney or pancreas graft(s)?

  Background:
    Given Clyde is a clinician
    And Patty is a patient in the system

  Scenario: Add patient to the transplant wait list
    When Clyde creates a transplant for Patty with status "Active"
    Then Patty is on the transplant wait list

  Scenario: Enter transplant details
    Given Patty has a transplant recorded
    When Clyde updates the transplant with transplant details
    Then Patty's transplant get updated

