Feature: Assigning a GP to a patient

  A logged in user assigns a GP (aka Primary Care Physician) to a patient

 @web @javascript @wip
  Scenario: A user assigned a GP to a patient
    Given Clyde is a clinician
    And Patty is a patient
    And Phylis is a primary care physician
    When Clyde assigns Phylis to Patty as a primary care physician
    Then Phylis is now Patty's primary care physician
