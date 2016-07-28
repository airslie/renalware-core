Feature: Viewing required pathology for a patient

  A clinician should be able to view a list of observations required for a patient.

  The observations required are determined by the global request algorithm and the patient request algorithm.

  Background:
    Given the global rule sets:
      | request_description_code | BFF    |
      | clinic                   | Access |
      | frequency_type           | Always |
    And the rule set contains these rules:
      | type              | id  | operator | value |
      | ObservationResult | HGB | <        | 100   |
    And Patty is a patient
    And Patty has observed an HGB value of 99
    And Patty has a recorded patient rule:
      | lab              | Biochemistry  |
      | test_description | Test for HepB |
      | frequency_type   | Always        |

  @web
  Scenario:
    Given Clyde is a clinician
    When Clyde views the list of required pathology for Patty in clinic Access
    Then Clyde sees these request descriptions from the global algorithm
      | Code | Lab          | Name                |
      | BFF  | Biochemistry | B12/FOLATE/FERRITIN |
    And Clyde sees these observations from the patient algorithm
      | Lab              | Biochemistry        |
      | Description      | Test for HepB       |
      | Sample # Bottles |                     |
      | Sample Type      |                     |
      | Frequency        | Always              |
      | Last Observed    |                     |
      | Start Date       |                     |
      | End Date         |                     |

