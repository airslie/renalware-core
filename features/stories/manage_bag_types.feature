Feature: An admin manages the bag types list

  Background:
    Given that I'm logged in

    Scenario: An admin adds a new bag type to bag types list
      Given that I'm on the add a new bag type page
      When I complete the form for a bag type
      Then I should see the new bag type on the bag type list

    Scenario: An admin edits a saved bag type in bag types list
      Given there are PD bag types in the database
        And that I choose to edit a bag type
      When I complete the form for editing a bag type
      Then I should see the updated bag type on the bag types list

    Scenario: An admin soft deletes a saved bag type in bag types list
      Given there are PD bag types in the database
      When I choose to soft delete a bag type
      Then I should no longer see the soft deleted bag type on the bag types list

