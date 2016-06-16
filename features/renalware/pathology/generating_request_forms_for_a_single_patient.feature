Feature: Generating request forms for a single patient

  A clinician generates a request form for a single patient.

  The pathology request form is a set of instructions for a given patient which is handed to the
  pathology department in order for them to know which observations to carry out on the patient.

  After the observations are made by the pathology department Renalware will receive the observation
  results from the HL7 feed.

  The observations are grouped by the specified lab and listed alphabetically.

  The doctor, telephone number & clinic fields on the form are editable once the form has been generated.

  Background:
    Given the date today is 12-10-2016
    And the following users:
      | Aaron Aaronofsky |
      | Zoe Zimmerman    |
    And Clyde is a clinician
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
  Scenario: A clinician generated the forms for a single patient
    When Clyde generates the request form for Patty
    Then Clyde sees these details at the top of Patty's form
      | patient_name    | THEPATIENT PATTY |
      | date            | 12-10-2016       |
      | date_of_birth   | 25-12-1961       |
      | consultant      | Aaron Aaronofsky |
      | clinical_detail | Access           |
      | contact         | Access           |
      | telephone       |                  |
    And Clyde sees the following pathology requirements for Patty:
      | global_pathology  |               |
      | patient_pathology | Test for HepB |

  @web
  Scenario: A clinician generated the forms for a single patient and requests a specific doctor, clinic and telephone number
    When Clyde generates the request form for Patty
    And Clyde chooses the consultant Zoe Zimmerman
    And Clyde chooses the clinic Transplant
    Then Clyde sees these details at the top of Patty's form
      | patient_name    | THEPATIENT PATTY |
      | date            | 12-10-2016       |
      | date_of_birth   | 25-12-1961       |
      | consultant      | Zoe Zimmerman    |
      | clinical_detail | Transplant       |
      | contact         | Transplant       |
      | telephone       |                  |
    And Clyde sees the following pathology requirements for Patty:
      | global_pathology  | BFF           |
      | patient_pathology | Test for HepB |

