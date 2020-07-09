Feature: Managing a patient's allergies

  Background:
    Given Clyde is a clinician
    And Patty is a patient

  @web @javascript
  Scenario: A clinician adds allergies to a patient
    When Clyde views add the following allergies to Patty
      | description        |
      | Nuts               |
      | Penicillin         |
    Then Patty has the following allergies
      | description        |
      | Nuts               |
      | Penicillin         |

  @web @javascript
  Scenario: A clinician removes allergies from a patient and marks her as having No Known Allergies
    Given Patty has these allergies
      | description        |
      | Nuts               |
      | Penicillin         |
    When Clyde removes the "Nuts" allergy
     And Clyde removes the "Penicillin" allergy
    Then Patty has the following allergies
      | description        |
    And Patty has these archived allergies
      | description        |
      | Penicillin         |
      | Nuts               |
    And Clyde is able to mark Patty as having No Known Allergies
