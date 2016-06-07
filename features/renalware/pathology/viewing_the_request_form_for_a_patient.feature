Feature: Viewing the request form for a patient

  A clinician should be able to view a list of global & patient observations required for a patient
  in the CRS format.

  The observations should be grouped by lab and listed alphabetically.

  The doctor, telephone number & clinic fields on the form should be changeable.

  Background:
    Given the global rule sets:
      | request_description_code | BFF        |
      | clinic                   | Transplant |
      | frequency_type           | Always     |
    And the rule set contains these rules:
      | type              | id  | operator | value |
      | ObservationResult | HGB | <        | 100   |
    And Patty is a patient
    And Patty has observed an HGB value of 99
    And Patty has a patient rule:
      | lab              | Biochemistry  |
      | test_description | Test for HepB |
      | frequency_type   | Always        |

  @web
  Scenario: Clyde views the form without request any specific form details
    Given Clyde is a clinician
    When Clyde views the pathology request form for Patty
    Then Clyde sees these details at the top of the form
      | Patient Name:    | THEPATIENT PATTY | Date:         | TODAYS_DATE     |
      | DOB:             | 25/12/1961       | Consultant:   | Emmett Eichmann |
      | Clinical Detail: | AKI              | Contact:      | AKI             |
      |                  |                  | Bleep/Tel No: | 1877713         |
    And Clyde sees this patient specific test: Test for HepB

  @web
  Scenario: Clyde views the form and requests specific form details
    Given Clyde is a clinician
    When Clyde enters clinic Transplant
    And Clyde enters doctor Emmett Eichmann
    And Clyde enters telephone number 7921838959
    And Clyde views the pathology request form for Patty
    Then Clyde sees these details at the top of the form
      | Patient Name:    | THEPATIENT PATTY | Date:         | TODAYS_DATE     |
      | DOB:             | 25/12/1961       | Consultant:   | Emmett Eichmann |
      | Clinical Detail: | Transplant       | Contact:      | Transplant      |
      |                  |                  | Bleep/Tel No: | 7921838959     |
