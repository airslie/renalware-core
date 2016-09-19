Feature: Recording a prescription

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web @javascript
  Scenario: A clinician recorded the prescription for a patient
    When Clyde records the prescription for Patty
    Then the prescription is recorded for Patty

  @web @javascript
  Scenario: A clinician recorded the prescription for a patient with a termination date

    The administration (e.g. injection) of certain drugs requires a trained professional
    (i.e. Nurse) and the HD session provides this opportunity.

    When Clyde records the prescription for Patty with a termination date
    Then the prescription is recorded for Patty
    And Clyde is recorded as the user who terminated the prescription

 @web @javascript
  Scenario: A clinician flagged a prescription to be administered during an HD session
    When Clyde flags the prescription for Patty to be administered during an HD session
    Then Clyde is prompted to administer the prescription during Patty's future HD sessions
