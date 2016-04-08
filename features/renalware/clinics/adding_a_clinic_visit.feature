Feature: A Doctor adds a clinic visit for a patient

  Background:
    Given Patty is a patient
      And Clyde is a clinician
      And Clyde is logged in
      And Clinics
        | id | name    |
        | 1  | Access  |
        | 2  | AKI     |
        | 3  | Anaemia |

  @web
  Scenario: Clyde adds a clinic visit for Patty
    Given Clyde is on Patty's clinic visits index
    When Clyde chooses to add a clinic visit
      And records Patty's clinic visit
    Then Patty's clinic visit should exist
