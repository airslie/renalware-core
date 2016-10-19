Feature: Assign a person as a patient's contact

  In order to associate a person as a patient's default CC for the purpose of
  drafting letters, a person must be assigned as a patient's contact. This
  assignment can be made during the drafting processing or done as an isolated
  task.

  Background:
    Given Patty is a patient
    And Clyde is a clinician

  @web @javascript
  Scenario: The clinician assigned a person to the patient as a contact flagging them as a default CC.
    Given Sam is a social worker
    When Clyde assigns Sam as a contact for Patty flagging them as a default CC
    Then Sam is listed as Patty's available contacts
    And Sam is listed as Patty's default CC's

  @web @javascript
  Scenario: The clinician assigned a person to the patient as a contact with a description.
    Given Sam is a social worker
    When Clyde assigns Sam as a contact for Patty describing them as "Referring Physician"
    Then Sam is listed as Patty's available contacts as a "Referring Physician"

  @web @javascript
  Scenario: The clinician assigned a person to the patient as a contact with a non-standard description.
    Given Sam is a social worker
    When Clyde assigns Sam as a contact for Patty describing them as Great Aunt
    Then Sam is listed as Patty's available contacts as Great Aunt

  @web @javascript @wip
  Scenario: The clinician added a new person as a contact for the patient
    When Clyde adds Diana Newton as a District Nurse contact for Patty
    Then Diana is listed as Patty's available contacts
