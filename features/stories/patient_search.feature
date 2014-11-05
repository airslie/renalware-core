@wip
Feature: Search for a patient

Scenario: A doctor searches for a patient
  Given that I'm logged in
    And some patients who need renal treatment
    #quicksearch by hospital number, lastname, firstname or NHS number
    And I've searched for a patient
  Then they will see a list of matching results