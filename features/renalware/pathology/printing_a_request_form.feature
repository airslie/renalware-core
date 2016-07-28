Feature: Printing a request form

  A clinician prints a request form and the details of the request are saved. This is used by
  the request algorithm in order to not re-request certain tests unless enough time has passed.

  Background:
    Given Patty is a patient
    And Patty has a recorded patient rule:
      | lab              | Biochemistry  |
      | test_description | Test for HepB |
      | frequency_type   | Always        |
    And Patty has a request form generated:
      | clinic | Transplant |
      | consultant | Dr Hibbert |
      | telephone | 0161932263 |
      | global_requests | FULL BLOOD COUNT, MALARIA, VITAMIN B12 |
      | patient_requests | Test for HepB |

  @web
  Scenario: A clinician prints a request form
    When Clyde prints Patty's request form
    Then Patty has the request recorded:
      | clinic | Transplant |
      | consultant | Dr Hibbert |
      | telephone | 0161932263 |
      | global_requests | FULL BLOOD COUNT, MALARIA, VITAMIN B12 |
      | patient_requests | Test for HepB |
      | created_by | Clyde |
