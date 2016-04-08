Feature: A Doctor edits an exisitng clinic visit for a patient

  Background:
    Given Patty is a patient
      And Clyde is a clinician
      And Clyde is logged in
      And Clinics
        | id | name    |
        | 1  | Access  |
        | 2  | AKI     |
        | 3  | Anaemia |
      And Patty has a clinic visit

  @web
  Scenario: Clyde edits one of Patty's clinic visits
    Given Clyde is on Patty's edit clinic visit page
    When Clyde updates Patty's clinic visit
    Then Patty's clinic visit should be updated
