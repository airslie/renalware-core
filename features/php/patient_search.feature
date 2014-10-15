Feature: Search for a patient 
@wip
Scenario: A doctor searches for a patient 
  Given a doctor has signed in
    And he searches for a patient in the quicksearch field
   #quicksearch by hospital number, lastname, firstname or NHS number
  Then he will see a list of matching results