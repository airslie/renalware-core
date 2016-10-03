Feature: Assign a person as a patient's contact

  In order to associate a person as a patient's default CC for the purpose of
  drafting letters, a person must be assigned as a patient's contact. This
  assignment can be made during the drafting processing or done as an isolated
  task.

  @wip
  Scenario:
    Given Patty is a patient
    And Sam is a social worker
    And Clyde is a clinician
    When Clyde assigns Sam as a contact for Patty
    Then Sam is listed as Patty's available contacts
