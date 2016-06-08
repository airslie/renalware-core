Feature: Viewing the request form for a patient

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

  @web
  Scenario: A clinician viewed the form and requested a specific doctor and clinic
    Given Clyde is a clinician
    When Clyde generates a request form with the following:
      | clinic  | Transplant    |
      | doctor  | Zoe Zimmerman |
      | patient | Patty         |
    Then Clyde sees these details at the top of the form
      | Patient Name:    | THEPATIENT PATTY | Date:         | 12-10-2016    |
      | DOB:             | 25-12-1961       | Consultant:   | Zoe Zimmerman |
      | Clinical Detail: | Transplant       | Contact:      | Transplant    |
      |                  |                  | Bleep/Tel No: | 7921838959    |
    And Clyde sees this patient specific test: Test for HepB
    And Clyde sees the request description BFF required

  @web
  Scenario: A clinician viewed the form and requested a specific doctor, clinic and telephone number
    Given Clyde is a clinician
    When Clyde generates a request form with the following:
      | clinic           | Transplant    |
      | doctor           | Zoe Zimmerman |
      | patient          | Patty         |
      | telephone_number | 123           |
    Then Clyde sees these details at the top of the form
      | Patient Name:    | THEPATIENT PATTY | Date:         | 12-10-2016       |
      | DOB:             | 25-12-1961       | Consultant:   | Zoe Zimmerman    |
      | Clinical Detail: | Transplant       | Contact:      | Transplant       |
      |                  |                  | Bleep/Tel No: | 123              |
    And Clyde sees this patient specific test: Test for HepB
    And Clyde sees the request description BFF required
