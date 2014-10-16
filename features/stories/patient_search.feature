Feature: Search for a patient

Scenario: A doctor searches for a patient
  Given that I'm logged in
    And some patients who need renal treatment
    #quicksearch by hospital number, lastname, firstname or NHS number
    And I've searched for a patient
    And I've selected the patient from the search results
  Then he will see a list of matching results