Feature: An admin adds a new modality to existing modality list


Background:
  Given that I'm logged in
    And there are modalities in the database
  
Scenario: An admin adds a new modal to modality list
  Given that I'm on the add a new modal page
  When I complete the form for a new modal
  Then I should see the new modal on the modalities list

@wip
Scenario: An admin edits a modal in the modalities list
  Given that I choose to edit a modality
  When I complete the form for editing a modality
  Then I should see the updated drug on the modality list

