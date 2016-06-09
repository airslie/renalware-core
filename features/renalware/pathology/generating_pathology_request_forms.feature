Feature: Generating pathology request forms

  A clinician views the list of global & patient observations required for a patient in a specific format
  so that the form can be printed and given to a pathology department for processing.

  The observations will then be made by the pathologist and eventually Renalware will receive the observation
  results from the HL7 feed.

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
    And Don is a patient
    And Don has observed an HGB value of 100
    And Don has a patient rule:
      | lab              | Biochemistry  |
      | test_description | Test for HIV  |
      | frequency_type   | Always        |

  @web
  Scenario: A clinician generated the forms for a single patient and request a specific doctor and clinic
    Given Clyde is a clinician
    When Clyde generates a set of request forms with the following:
      | clinic   | Transplant    |
      | doctor   | Zoe Zimmerman |
      | patients | Patty         |
    Then Clyde sees these details at the top of Patty's form
      | patient_name     | THEPATIENT PATTY |
      | date             | 12-10-2016       |
      | date_of_birth    | 25-12-1961       |
      | consultant       | Zoe Zimmerman    |
      | clinical_detail  | Transplant       |
      | contact          | Transplant       |
      | telephone        | 7921838959       |
    And Clyde sees this patient specific test for Patty: Test for HepB
    And Clyde sees the request description BFF required for Patty

  @web
  Scenario: A clinician generated the forms for a single patient and request a specific doctor, clinic and telephone number
    Given Clyde is a clinician
    When Clyde generates a set of request forms with the following:
      | clinic    | Transplant    |
      | doctor    | Zoe Zimmerman |
      | patients  | Patty         |
      | telephone | 123           |
    Then Clyde sees these details at the top of Patty's form
      | patient_name    | THEPATIENT PATTY |
      | date            | 12-10-2016       |
      | date_of_birth   | 25-12-1961       |
      | consultant      | Zoe Zimmerman    |
      | clinical_detail | Transplant       |
      | contact         | Transplant       |
      | telephone       | 123              |
    And Clyde sees this patient specific test for Patty: Test for HepB
    And Clyde sees the request description BFF required for Patty

  @web
  Scenario: A clinician generated the forms for multiple patient and request a specific doctor, clinic and telephone number
    Given Clyde is a clinician
    When Clyde generates a set of request forms with the following:
      | clinic    | Transplant    |
      | doctor    | Zoe Zimmerman |
      | patients  | Patty, Don    |
      | telephone | 123           |
    Then Clyde sees these details at the top of Patty's form
      | patient_name    | THEPATIENT PATTY |
      | date            | 12-10-2016       |
      | date_of_birth   | 25-12-1961       |
      | consultant      | Zoe Zimmerman    |
      | clinical_detail | Transplant       |
      | contact         | Transplant       |
      | telephone       | 123              |
    And Clyde sees this patient specific test for Patty: Test for HepB
    And Clyde sees the request description BFF required for Patty
    And Clyde sees these details at the top of Don's form
      | patient_name    | THEDONOR DON     |
      | date            | 12-10-2016       |
      | date_of_birth   | 01-01-1989       |
      | consultant      | Zoe Zimmerman    |
      | clinical_detail | Transplant       |
      | contact         | Transplant       |
      | telephone       | 123              |
    And Clyde sees this patient specific test for Don: Test for HIV
    And Clyde does not see the request description BFF required for Don
