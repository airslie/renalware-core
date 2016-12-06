Feature: Listing patients with a current ESA prescription

  A user can view all patients who currently have one or more ESA drugs prescribed.

  Rules:
    - Only patients with a current ESA prescription are listed
    - A patient is listed only once even if they have >1 matching prescriptions

  @web
  Scenario: A clinician views the list of current prescriptions
    Given Nancy is a nurse
    And these patients and prescriptions
      | patient         | terminated | drug_type  |
      | RABBIT, Roger   | false      | ESA        |
      | RABBIT, Jessica | true       | ESA        |
      | RABBIT, Jessica | false      | ESA        |
      | BUNNY, Bugs     | true       | ESA        |
      | DUCK, Donald    | false      | Antibiotic |
    When Nancy views the ESA patients list
    Then Nancy sees only these patients
      | patient         |
      | RABBIT, Roger   |
      | RABBIT, Jessica |
