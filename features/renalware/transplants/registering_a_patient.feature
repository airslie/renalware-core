Feature: Registering a patient on the wait list

  A patient requires the transplant of one or many organs: kidney, pancreas or liver. To
  receive a transplant a patient needs to be registered on a wait list.

  Background:
    And Clyde is a clinician
    And Patty is a patient
    And Patty has the Transplant modality

  @web
  Scenario: A clinician registered a patient on the transplant wait list
    When Clyde registers Patty on the wait list with status "Active" starting on "24-10-2015"
    Then Patty has an active transplant registration since "24-10-2015"
    And the current status was set by Clyde

  @web
  Scenario: A clinician updated a patient's registration
    Given Patty is registered on the wait list
    Then Clyde can update Patty's transplant registration

  @web
  Scenario: A clinician submitted an erroneous registration
    When Clyde submits an erroneous registration
    Then the registration is not accepted

  Scenario: A clinician submitted a pre-dated registration
    When Clyde submits a pre-dated registration
    Then the registration is not accepted
