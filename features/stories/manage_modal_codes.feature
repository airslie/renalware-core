Feature: An admin adds a new modality to existing modality list

Background:
  Given that I'm logged in
    And there are modality codes in the database

Scenario: An admin adds a new modal to modality list
  Given that I'm on the add a new modal page
  When I complete the form for a new modal
  Then I should see the new modal on the modalities list

Scenario: An admin edits a modal in the modalities list
  Given that I choose to edit a modality
  When I complete the form for editing a modality
  Then I should see the updated drug on the modality list

Scenario: An admin soft deletes a modal in the modalities list
  Given I am on the modalities index
  When I choose to soft delete a modal
  Then I should see the modal removed from the modalities list


