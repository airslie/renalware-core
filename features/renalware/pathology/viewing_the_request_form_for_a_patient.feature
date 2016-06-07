Feature: Viewing the request form for a patient

  A clinician views a list of global & patient observations required for a patient in the CRS format.

  The observations are grouped by the specified lab and listed alphabetically.

  The doctor, telephone number & clinic fields on the form are changeable.

  Background:
    Given Aaron Aaronofsky is a doctor with telephone number: 203123123
    And Zoe Zimmerman is a doctor with telephone number: 7921838959
    And the date today is 12-10-2016
    And the global rule sets:
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
  Scenario: A clinician viewed the form without requesting any specific form details
    Given Clyde is a clinician
    When Clyde views the pathology request form for Patty
    Then Clyde sees these details at the top of the form
      | Patient Name:    | THEPATIENT PATTY | Date:         | 12-10-2016       |
      | DOB:             | 25-12-1961       | Consultant:   | Aaron Aaronofsky |
      | Clinical Detail: | AKI              | Contact:      | AKI              |
      |                  |                  | Bleep/Tel No: | 203123123        |
    And Clyde sees this patient specific test: Test for HepB
    And Clyde sees no global tests required

  @web
  Scenario: A clinician viewed the form and requested a specific doctor
    Given Clyde is a clinician
    When Clyde enters clinic Transplant
    And Clyde enters doctor Zoe Zimmerman
    And Clyde views the pathology request form for Patty
    Then Clyde sees these details at the top of the form
      | Patient Name:    | THEPATIENT PATTY | Date:         | 12-10-2016    |
      | DOB:             | 25-12-1961       | Consultant:   | Zoe Zimmerman |
      | Clinical Detail: | Transplant       | Contact:      | Transplant    |
      |                  |                  | Bleep/Tel No: | 7921838959    |
    And Clyde sees this patient specific test: Test for HepB
    And Clyde sees the request description BFF required

  @web
  Scenario: A clinician viewed the form and requested a specific telephone number and clinic
    Given Clyde is a clinician
    When Clyde enters clinic Transplant
    And Clyde enters telephone number 123
    And Clyde views the pathology request form for Patty
    Then Clyde sees these details at the top of the form
      | Patient Name:    | THEPATIENT PATTY | Date:         | 12-10-2016       |
      | DOB:             | 25-12-1961       | Consultant:   | Aaron Aaronofsky |
      | Clinical Detail: | Transplant       | Contact:      | Transplant       |
      |                  |                  | Bleep/Tel No: | 123              |
    And Clyde sees this patient specific test: Test for HepB
    And Clyde sees the request description BFF required
