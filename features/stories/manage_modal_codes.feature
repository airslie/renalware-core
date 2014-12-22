Feature: An admin adds a new modality to existing modality list


Background:
  Given that I'm logged in
  
@wip
Scenario: An admin adds a new modal to modality list
  Given that I'm on the add a new modal page
  When I complete the form for a new modal
  Then I should see the new modal on the modalities list

