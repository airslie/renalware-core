Feature: Assign a person as a patient's contact

  In order to associate a person as a patient's default CC for the purpose of
  drafting letters, a person must be assigned as a patient's contact. This
  assignment can be made during the drafting processing or done as an isolated
  task.

  @web @javascript
  Scenario: The clinician assigned a person to the patient as a contact.
    Given Patty is a patient
    And Sam is a social worker
    And Clyde is a clinician
    When Clyde assigns Sam as a contact for Patty
    Then Sam is listed as Patty's available contacts

  @web @javascript
  Scenario: The clinician assigned a person to the patient as a contact flagging them as a default CC.
    Given Patty is a patient
    And Sam is a social worker
    And Clyde is a clinician
    When Clyde assigns Sam as a contact for Patty flagging them as a default CC
    Then Sam is listed as Patty's available contacts
    And Sam is listed as Patty's default CC's

  @web @javascript
  Scenario: The clinician assigned a person to the patient as a contact with a description.
    Given Patty is a patient
    And Sam is a social worker
    And Clyde is a clinician
    When Clyde assigns Sam as a contact for Patty flagging describing them as "Referring Physician"
    Then Sam is listed as Patty's available contacts as a "Referring Physician"

  @web @javascript
  Scenario: The clinician assigned a person to the patient as a contact with a non-standard description.
    Given Patty is a patient
    And Sam is a social worker
    And Clyde is a clinician
    When Clyde assigns Sam as a contact for Patty flagging describing them as Great Aunt
    Then Sam is listed as Patty's available contacts as Great Aunt
