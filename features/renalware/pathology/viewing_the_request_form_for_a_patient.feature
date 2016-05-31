Feature: Viewing the request form for a patient

  A clinician should be able to view a list of global & patient observations required for a patient
  in the CRS format.

  The observations should be grouped by lab and listed alphabetically.

  The doctor, telephone number & clinic fields on the form should be changeable.

  Background:
    Given John Merrill is a doctor with telephone number 123
    And the global rule sets:
      | request_description_code | BFF    |
      | clinic                   | Access |
      | frequency_type           | Always |
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
  Scenario:
    Given Clyde is a clinician
    When Clyde views the pathology request form for Patty
    And Clyde selects clinic Access
    And Clyde selects doctor John Merrill
    And Clyde selects telephone number 07921838959
    Then Clyde sees these details at the top of the form
    | Patient Name:    | ThePatient Patty | Date:         | TODAYS_DATE  |
    | DOB:             | 01/01/1926       | Consultant:   | John Merrill |
    | Clinical Detail: | Access           | Contact:      | Transplant   |
    |                  |                  | Bleep/Tel No: | 07921838959  |
