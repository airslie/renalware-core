Feature: Search for a patient
  As a clinician
  I want to quicksearch by local patient id, lastname, firstname or NHS number

  Background:
    Given there are ethnicities in the database
      And that I'm logged in
      And some patients who need renal treatment
      And I am on the patients list

  Scenario: A clinician searches for a patient by hospital code
    When I search for a patient with "Z999991"
    Then the following patients are found: "RABBIT, R"

  Scenario: A clinician searches for a patient by partial family name and given name
    When I search for a patient with "rabb r"
    Then the following patients are found: "RABBIT, R"

  Scenario: A clinician searches for a patient by family name
    When I search for a patient with "casper"
    Then the following patients are found: "CASPER, G"

  Scenario: A clinician searches for a patient by NHS number
    When I search for a patient with "1000124502"
    Then the following patients are found: "DAY, D"
