Feature: Listing patients with a current ESA prescription

  A user can view all patients who currently have one or more ESA drugs prescribed.

  Rules:
    - Only patients with a current esa prescription are listed
    - A patient is listed only once even if they have >1 matching prescriptions

  Background:
    Given Clyde is a clinician
    And these patients and prescriptions
      | patient        | terminated | drug_type  |
      | Roger Rabbit   | false      | ESA        |
      | Jessica Rabbit | true       | ESA        |
      | Jessica Rabbit | false      | ESA        |
      | Bugs Bunny     | true       | ESA        |
      | Donald Duck    | false      | Antibiotic |

  @web
  Scenario: A clinician views the list of current prescriptions
    When Clyde views the ESA patients list
    Then Clyde sees only these patients
      | patient         |
      | Roger Rabbit    |
      | Jessica Rabbit  |
